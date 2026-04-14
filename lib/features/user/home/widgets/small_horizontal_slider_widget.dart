import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'ad_dialogue.dart';

class SmallHorizontalSlider extends StatelessWidget {
  const SmallHorizontalSlider({
    super.key,
    required this.width,
    required this.ads,
  });

  final double width;
  final List<Map<String, dynamic>> ads;

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) {
      return const SizedBox.shrink();
    }

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
        const SizedBox(height: 10),
        SizedBox(
          height: 125,
          child: CarouselSlider.builder(
            itemCount: ads.length,
            itemBuilder: (context, index, realIndex) {
              final ad = ads[index];

              return GestureDetector(
                onTap: () {
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
            options: CarouselOptions(
              height: 125,
              viewportFraction: 1,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enableInfiniteScroll: ads.length > 1,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }
}
