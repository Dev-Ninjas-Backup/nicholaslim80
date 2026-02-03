import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/recipient_part/recipient_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/model.dart';
import '../sender_part/screen/screen.dart';

class StackedCollectFormController extends GetxController {
  // .obs makes variables reactive so UI updates automatically
  var selectedFilterIndex = 0.obs;
  var selectedTypeFilter = 'ALL'.obs; // 'ALL', 'SENDER', 'RECEIVER'
  var isLoading = false.obs;
  var addressList = <StackedAddressModel>[].obs;
  var selectedAddress = Rxn<StackedAddressModel>();

  // Filter names
  final List<String> filters = ["Recent", "Frequently Used", "Saved"];
  final List<String> typeFilters = ["All", "Sender", "Receiver"];

  // Raw lists
  List<StackedAddressModel> _savedList = [];
  List<StackedAddressModel> _recentList = [];
  List<StackedAddressModel> _frequentlyList = [];

  // Address type to filter by (passed from parent screen)
  String? _addressTypeFilter;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    fetchAddresses();
  }

  // Initialize with address type filter (called from screen)
  void initializeWithAddressType(String? addressType) {
    if (addressType != null) {
      _addressTypeFilter = addressType;
      // Set the type filter based on addressType
      if (addressType == 'SENDER') {
        selectedTypeFilter.value = 'SENDER';
      } else if (addressType == 'RECEIVER') {
        selectedTypeFilter.value = 'RECEIVER';
      }
    }
  }

  // Change active filter tab
  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    // show already fetched data if available, otherwise fetch
    if (_savedList.isNotEmpty || _recentList.isNotEmpty || _frequentlyList.isNotEmpty) {
      _applyFilter();
    } else {
      fetchAddresses();
    }
  }

  // Change type filter (All, Sender, Receiver)
  void changeTypeFilter(int index) {
    switch (index) {
      case 0:
        selectedTypeFilter.value = 'ALL';
        break;
      case 1:
        selectedTypeFilter.value = 'SENDER';
        break;
      case 2:
        selectedTypeFilter.value = 'RECEIVER';
        break;
    }
    _applyFilter();
  }

  // Fetch address data from API and categorize
  Future<void> fetchAddresses() async {
    if (isLoading.value) return;

    isLoading.value = true;
    addressList.clear();

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      final uri = Uri.parse(ApiEndPoint.getDestination);
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint('🚀 DESTINATION RESPONSE: ${response.statusCode} & 📦 Body: ${response.body}');
        if (decoded['success'] == true && decoded['data'] != null) {
          final List list = decoded['data'];

          // Map to model and decide icon based on type
          List<StackedAddressModel> all = list.map<StackedAddressModel>((e) {
            String icon = e['type'] == 'SENDER' ? IconPath.location : IconPath.locationBlue;
            return StackedAddressModel.fromJson(Map<String, dynamic>.from(e), iconPath: icon);
          }).toList();

          // Categorize by recency/frequency
          _savedList = all.where((a) => a.isSaved == true).toList();
          _recentList = all.where((a) => a.lastUsedAt != null && a.isSaved == false).toList();
          _frequentlyList = all.where((a) => a.useCount >= 1 && a.isSaved == false && a.lastUsedAt == null).toList();

          // sort frequently by useCount desc
          _frequentlyList.sort((a, b) => b.useCount.compareTo(a.useCount));

          _applyFilter();
        } else {
          debugPrint('No data in destination response');
        }
      } else {
        debugPrint('Destination API failed: ${response.statusCode}');
        EasyLoading.showError('Failed to load addresses');
      }
    } catch (e) {
      debugPrint('Error fetching destinations: $e');
      EasyLoading.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    // Get filtered list based on recency/frequency
    List<StackedAddressModel> filtered;
    
    switch (selectedFilterIndex.value) {
      case 0:
        filtered = _recentList;
        break;
      case 1:
        filtered = _frequentlyList;
        break;
      case 2:
        filtered = _savedList;
        break;
      default:
        filtered = _recentList;
    }

    // Apply type filter (SENDER, RECEIVER, or ALL)
    if (selectedTypeFilter.value == 'ALL') {
      addressList.assignAll(filtered);
    } else {
      addressList.assignAll(
        filtered.where((a) => a.type == selectedTypeFilter.value).toList(),
      );
    }
  }

  void onAddressTap(StackedAddressModel address) {
    selectedAddress.value = address;

    // decide view by address.type
    if (address.type == 'SENDER') {
      Get.to(() => StackedSenderView(address: address));
    } else {
      Get.to(() => StackedRecipientView(address: address));
    }
  }
}
