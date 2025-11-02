import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/controller/refer_and_earn_controller.dart';

class ReferAndEarnScreen extends StatelessWidget {
  ReferAndEarnScreen({super.key});

  final ReferAndEarnController ctrl = Get.put(ReferAndEarnController());

  @override
  Widget build(BuildContext context) {
    // sizing helpers
    final padding = 20.0;

    return Scaffold(
      backgroundColor: Color(0xFFFBF6E7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Refer & Earn',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              Text(
                'Invite friends to and earn rewards for every sign-up',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 18),

              // referral card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      // Referral code row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your referral code:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 6),
                              Obx(
                                () => Text(
                                  ctrl.referralCode.value,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: ctrl.copyCode,
                            icon: Icon(Icons.copy_outlined),
                          ),
                        ],
                      ),

                      Divider(height: 20),

                      // Referral link row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your referral link:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Obx(
                                  () => Text(
                                    ctrl.referralLink.value,
                                    style: TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: ctrl.copyLink,
                            icon: Icon(Icons.copy_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 22),

              // List options
              GestureDetector(
                onTap: ctrl.openRewards,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Your Rewards',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              Divider(height: 1),

              GestureDetector(
                onTap: ctrl.openHowItWorks,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              Divider(height: 1),

              // spacer to push button to bottom
              Spacer(),

              // Invite friends button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ctrl.onInvitePressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Color(0xFFFFC600), // yellow
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.black87,
                  ),
                  child: Text(
                    'Invite friends',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
