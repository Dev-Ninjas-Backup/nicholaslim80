import 'package:flutter/widgets.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

class CustomAppBarUser extends StatelessWidget {
  final String title;
  final Widget? action;

  const CustomAppBarUser({required this.title, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(IconPath.arrowBackIcon, height: 18, width: 18),

              SizedBox(width: 17),

              Text(
                title,
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          ?action,
        ],
      ),
    );
  }
}
