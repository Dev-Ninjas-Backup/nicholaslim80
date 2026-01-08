import 'package:ZipBee/features/user/finding_raider/model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


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
    EasyLoading.showSuccess('Review Submitted for ${inputRating.value} stars!');

    // Optional: Clear input
    // commentController.clear();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
