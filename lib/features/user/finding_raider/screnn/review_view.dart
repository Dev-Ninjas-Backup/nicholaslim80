import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/finding_raider/controller/review_controller.dart';
import 'package:nicholaslim80/features/user/finding_raider/model/review_model.dart';
import 'package:nicholaslim80/features/user/finding_raider/screnn/rate_rider_tip.dart';

class ReviewView extends StatelessWidget {
  ReviewView({super.key});

  // Inject the controller
  final ReviewController controller = Get.put(ReviewController());

  // Define Colors locally or in a separate theme file
  final Color kPrimaryYellow = Color(0xFFFFC107);
  final Color kGreen = Color(0xFF2ECC71);
  final Color kLime = Color(0xFFCDDC39);
  final Color kOrange = Color(0xFFFFA726);
  final Color kRed = Color(0xFFFF3D00);
  final Color kGreyText = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroungColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Reviews',
          style: getTextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Header & Statistics ---
            Center(
              child: Column(
                children: [
                  Text(
                    "4.0",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  buildStarRow(4.0, size: 24),
                  SizedBox(height: 5),
                  Text(
                    "Based on 24 reviews",
                    style: TextStyle(color: kGreyText, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            buildProgressBar("Excellent", 0.9, kGreen),
            buildProgressBar("Good", 0.7, kLime),
            buildProgressBar("Average", 0.5, kOrange),
            buildProgressBar("Poor", 0.15, kRed),

            SizedBox(height: 30),

            // --- 2. Rating Input Form ---
            Text(
              "Rate rider",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Your feeback helps us to improve your experience!",
              style: TextStyle(color: kGreyText, fontSize: 13),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Obx(() => buildInteractiveStars(controller.inputRating.value)),
                SizedBox(width: 10),
                Text("Rate to earn", style: TextStyle(color: kGreyText)),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "What influenced your rating?",
              style: TextStyle(color: kGreyText, fontSize: 14),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.commentController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Interactive Tags
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Obx(
                        () => buildRadioItem(
                          "Fast delivery",
                          controller.isFastDelivery.value,
                          () => controller.isFastDelivery.toggle(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => buildRadioItem(
                          "Item/s delivered in\ngood condition",
                          controller.isGoodCondition.value,
                          () => controller.isGoodCondition.toggle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Obx(
                        () => buildRadioItem(
                          "Slow in delivery",
                          controller.isSlowDelivery.value,
                          () => controller.isSlowDelivery.toggle(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => buildRadioItem(
                          "Item/s delivered\nin bad condition",
                          controller.isBadCondition.value,
                          () => controller.isBadCondition.toggle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 25),

            // Button(
            //   buttonText: 'Submit Review',
            //   textColor: Colors.black,
            //   backgroundColor: Colors.amber,
            //   onPressed: () {
            //     Get.to(RateRiderTip());
            //   },
            // ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.submitReview();
                  Get.to(RateRiderTip());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Submit Review",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // --- 3. Reviews List ---
            Obx(
              () => ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.reviews.length,
                separatorBuilder: (_, __) => Column(
                  children: [
                    SizedBox(height: 5),
                    Divider(thickness: 1, color: Colors.grey),
                    SizedBox(height: 5),
                  ],
                ),
                itemBuilder: (context, index) {
                  final review = controller.reviews[index];
                  return buildReviewCard(review);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Methods ---

  Widget buildReviewCard(Review review) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(review.imageUrl),
          backgroundColor: Colors.grey.shade200,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  buildStarRow(review.rating, size: 16),
                  SizedBox(width: 8),
                  Text(
                    review.rating.toString(),
                    style: TextStyle(color: kGreyText, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                review.comment,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProgressBar(String label, double percentage, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStarRow(double rating, {double size = 20}) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(Icon(Icons.star, color: kPrimaryYellow, size: size));
      } else if (i - 0.5 <= rating) {
        stars.add(Icon(Icons.star_half, color: kPrimaryYellow, size: size));
      } else {
        stars.add(
          Icon(Icons.star_border, color: Colors.grey.shade300, size: size),
        );
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  Widget buildInteractiveStars(double currentRating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            controller.inputRating.value = index + 1.0;
          },
          child: Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Icon(
              index < currentRating ? Icons.star : Icons.star_border,
              color: index < currentRating
                  ? kPrimaryYellow
                  : Colors.grey.shade300,
              size: 30,
            ),
          ),
        );
      }),
    );
  }

  Widget buildRadioItem(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryYellow : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryYellow,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
