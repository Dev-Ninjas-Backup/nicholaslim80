import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/finding_raider/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewController extends GetxController {
  final String orderId;
  final int? riderId;

  ReviewController({required this.orderId, required this.riderId});

  /// ---------------- STATE ----------------
  var inputRating = 4.0.obs;
  final commentController = TextEditingController();

  var isFastDelivery = true.obs;
  var isGoodCondition = true.obs;
  var isSlowDelivery = false.obs;
  var isBadCondition = false.obs;

  RxList<Review> reviews = <Review>[].obs;
  var isLoading = false.obs;

  /// summary (for header)
  var averageRating = 0.0.obs;
  var totalReviews = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (riderId != null) {
      fetchRatings();
    }
  }

  /// ---------------- FETCH REVIEWS ----------------
  Future<void> fetchRatings() async {
    if (riderId == null) return;

    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      final uri = Uri.parse('${ApiEndPoint.rating}?type=raider&id=$riderId');

      final res = await http.get(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      debugPrint("Fetch Rider Ratings Status: ${res.statusCode}");
      debugPrint("Fetch Rider Ratings Body: ${res.body}");

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final Map<String, dynamic> dataMap = body['data'] ?? {};
        final List list = dataMap['data'] ?? [];

        reviews.value = list
            .map(
              (e) => Review(
                name: e['userName'] ?? "User",
                imageUrl: e['userImage'] ?? "",
                rating: (e['rating_star'] ?? 0).toDouble(),
                comment: e['notes'] ?? "",
              ),
            )
            .toList();

        totalReviews.value = reviews.length;

        if (reviews.isNotEmpty) {
          double sum = reviews.fold(0, (p, e) => p + e.rating);
          averageRating.value = sum / reviews.length;
        } else {
          averageRating.value = 0;
        }
      } else {
        debugPrint("Failed to fetch ratings for riderId=$riderId");
      }
    } catch (e) {
      debugPrint("fetchRatings error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- RATING PERCENTAGES ----------------
  Map<String, double> getRatingPercentages() {
    if (reviews.isEmpty)
      return {"Excellent": 0.0, "Good": 0.0, "Average": 0.0, "Poor": 0.0};

    int excellent = reviews.where((r) => r.rating >= 5.0).length;
    int good = reviews.where((r) => r.rating >= 4.0 && r.rating <= 4.9).length;
    int average = reviews
        .where((r) => r.rating >= 3.0 && r.rating <= 3.9)
        .length;
    int poor = reviews.where((r) => r.rating < 3.0).length;
    int total = reviews.length;

    return {
      "Excellent": excellent / total,
      "Good": good / total,
      "Average": average / total,
      "Poor": poor / total,
    };
  }

  /// ---------------- SUBMIT REVIEW ----------------
  Future<void> submitReview() async {
    if (riderId == null) {
      EasyLoading.showError("Rider info unavailable");
      return;
    }

    try {
      EasyLoading.show(status: "Submitting...");
      final token = await SharedPreferencesHelper.getAccessToken();
      final userId = await SharedPreferencesHelper.getUserId();

      final int parsedOrderId = int.tryParse(orderId) ?? 0;

      final body = {
        "type": "raider",
        "orderId": parsedOrderId,
        "raiderId": riderId,
        "user_id": int.tryParse(userId.toString()) ?? 0,
        "rating_star": inputRating.value.toInt(),
        "notes": commentController.text.trim(),
        "delivery_quality": isGoodCondition.value
            ? "EXCELLENT"
            : isBadCondition.value
            ? "POOR"
            : "AVERAGE",
        "delivery_status": isFastDelivery.value ? "ON_TIME" : "LATE",
      };

      debugPrint("Submitting Review Body: ${jsonEncode(body)}");

      final res = await http.post(
        Uri.parse('${ApiEndPoint.rating}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint("Submit Review Status: ${res.statusCode}");
      debugPrint("Submit Review Response: ${res.body}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        EasyLoading.showSuccess("Review Submitted");
        commentController.clear();
        await fetchRatings();
      } else {
        EasyLoading.showError("Submit failed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("SubmitReview error: $e");
      EasyLoading.showError("Error submitting review");
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
