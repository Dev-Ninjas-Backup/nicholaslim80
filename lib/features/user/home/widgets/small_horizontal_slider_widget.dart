import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/service/ads_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'ad_dialogue.dart';

class SmallHorizontalSlider extends StatelessWidget {
  const SmallHorizontalSlider({super.key, required this.width});

  final double width;

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            "Find out more",
            style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 125,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: AdsService.fetchAds(),
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
        ),
      ],
    );
  }
}
