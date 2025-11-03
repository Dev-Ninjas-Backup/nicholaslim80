import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/controller/refer_and_earn_controller.dart';

class ReferralCard extends StatelessWidget {
  const ReferralCard({super.key, required this.ctrl});

  final ReferAndEarnController ctrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.9,

      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your referral code:',
                        style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6),
                      Obx(
                        () => Text(
                          ctrl.referralCode.value,
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your referral link:',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 6),
                        Obx(
                          () => Text(
                            ctrl.referralLink.value,
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
    );
  }
}
