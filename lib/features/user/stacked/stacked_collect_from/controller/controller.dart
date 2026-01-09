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
  var isLoading = false.obs;
  var addressList = <StackedAddressModel>[].obs;
  var selectedAddress = Rxn<StackedAddressModel>();

  // Filter names
  final List<String> filters = ["Recent", "Frequently Used", "Saved"];

  // Raw lists
  List<StackedAddressModel> _savedList = [];
  List<StackedAddressModel> _recentList = [];
  List<StackedAddressModel> _frequentlyList = [];

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    fetchAddresses();
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
        if (decoded['success'] == true && decoded['data'] != null) {
          final List list = decoded['data'];

          // Map to model and decide icon
          List<StackedAddressModel> all = list.map<StackedAddressModel>((e) {
            String icon = e['type'] == 'SENDER' ? IconPath.location : IconPath.locationBlue;
            return StackedAddressModel.fromJson(Map<String, dynamic>.from(e), iconPath: icon);
          }).toList();

          // Categorize
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
    switch (selectedFilterIndex.value) {
      case 0:
        addressList.assignAll(_recentList);
        break;
      case 1:
        addressList.assignAll(_frequentlyList);
        break;
      case 2:
        addressList.assignAll(_savedList);
        break;
      default:
        addressList.assignAll(_recentList);
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
