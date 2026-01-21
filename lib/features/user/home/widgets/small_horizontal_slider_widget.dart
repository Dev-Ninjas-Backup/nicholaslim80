import 'dart:convert';

import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api_end_point/api_end_point.dart';

class SmallHorizontalSlider extends StatelessWidget {
  const SmallHorizontalSlider({super.key, required this.width});

  final double width;

  Future<List<Map<String, dynamic>>> fetchAds() async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final response = await http.get(
      Uri.parse(ApiEndPoint.homePageAd),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List list = decoded['data']['data'];
      return List<Map<String, dynamic>>.from(list);
    } else {
      throw Exception("Failed to load ads");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SizedBox.shrink();
          }

          final ads = snapshot.data!;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ads.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final ad = ads[index];

              return SizedBox(
                width: width * 0.9,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE16B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ad['ad_title'] ?? 'Buy GPS',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                             SizedBox(height: 6),
                            // Text(
                            //   "Valid till ${ad['end_date']?.toString().split('T').first ?? ''}",
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w500,
                            //     color: AppColors.subtitleFontColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ad['ad_image'] != null
                            ? Image.network(
                                ad['ad_image'],
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  IconPath.mappin,
                                  height: 70,
                                  width: 70,
                                ),
                              )
                            : Image.asset(
                                IconPath.mappin,
                                height: 70,
                                width: 70,
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
