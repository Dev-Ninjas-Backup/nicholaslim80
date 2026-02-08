import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ad_dialogue.dart';

class SmallHorizontalSlider extends StatelessWidget {
  const SmallHorizontalSlider({super.key, required this.width});

  final double width;

  /// ---------------- API ----------------
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

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          final ads = snapshot.data!;

          return CarouselSlider.builder(
            itemCount: ads.length,
            itemBuilder: (context, index, realIndex) {
              final ad = ads[index];

              return GestureDetector(
                onTap: () {
                  /// 👉 open dialog and pass full map
                  showDialog(
                    context: context,
                    builder: (_) => AdDetailsDialog(ad: ad),
                  );
                },
                child: Container(
                  width: width,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE16B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      /// -------- TEXT --------
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
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// -------- IMAGE --------
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ad['ad_image'] != null
                            ? Image.network(
                                ad['ad_image'],
                                height: 125,
                                width: 150,
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

            /// -------- CAROUSEL SETTINGS --------
            options: CarouselOptions(
              height: 125,
              viewportFraction: 1, // show next item partially
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enableInfiniteScroll: ads.length > 1,
              scrollDirection: Axis.horizontal, // left → right
            ),
          );
        },
      ),
    );
  }
}
