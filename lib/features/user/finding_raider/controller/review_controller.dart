import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/finding_raider/model/review_model.dart';

class ReviewController extends GetxController {
  // --- State Variables ---
  var inputRating = 4.0.obs;
  final commentController = TextEditingController();

  // Feedback Tags (True = Selected)
  var isFastDelivery = true.obs;
  var isGoodCondition = true.obs;
  var isSlowDelivery = false.obs;
  var isBadCondition = false.obs;

  // --- Data Source ---
  final List<Review> reviews = [
    Review(
      name: "City Dinner",
      imageUrl: "https://i.pravatar.cc/150?img=11",
      rating: 5.0,
      comment:
          "Excellent work! Very punctual and maintained kitchen hygiene perfectly.",
    ),
    Review(
      name: "Bella Vista Restaurant",
      imageUrl: "https://i.pravatar.cc/150?img=33",
      rating: 4.5,
      comment:
          "Excellent work! Very punctual and maintained kitchen hygiene perfectly.",
    ),
    Review(
      name: "Bella Vista Restaurant",
      imageUrl: "https://i.pravatar.cc/150?img=12",
      rating: 4.5,
      comment:
          "Excellent work! Very punctual and maintained kitchen hygiene perfectly.",
    ),
    Review(
      name: "Bella Vista Restaurant",
      imageUrl: "https://i.pravatar.cc/150?img=59",
      rating: 4.5,
      comment:
          "Excellent work! Very punctual and maintained kitchen hygiene perfectly.",
    ),
    Review(
      name: "Bella Vista Restaurant",
      imageUrl: "https://i.pravatar.cc/150?img=60",
      rating: 4.5,
      comment:
          "Excellent work! Very punctual and maintained kitchen hygiene perfectly.",
    ),
  ].obs;

  // --- Logic Methods ---

  void submitReview() {
    // Here you would usually send data to an API
    Get.snackbar(
      "Success",
      "Review Submitted for ${inputRating.value} stars!",
      backgroundColor: AppColors.primaryButtonColor,
      colorText: AppColors.primaryFontColor,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
    );

    // Optional: Clear input
    // commentController.clear();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
