import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class SwipeButtonWidget extends StatefulWidget {
  final String leftText;
  final String rightText;
  final Color backgroundColor;
  final double height;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final String iconPath;

  const SwipeButtonWidget({
    super.key,
    required this.leftText,
    required this.rightText,
    required this.backgroundColor,
    this.height = 60,
    required this.onAccept,
    required this.onDecline,
    required this.iconPath,
  });

  @override
  State<SwipeButtonWidget> createState() => _SwipeButtonWidgetState();
}

class _SwipeButtonWidgetState extends State<SwipeButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animCtrl;
  late Animation<double> anim;
  double dragX = 0.0;
  double maxDrag = 0.0;
  double minDrag = 0.0;

  @override
  void initState() {
    super.initState();
    animCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    animCtrl.dispose();
    super.dispose();
  }

  void onPanStart(DragStartDetails details) => animCtrl.stop();

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragX += details.delta.dx;
      dragX = dragX.clamp(minDrag, maxDrag);
    });
  }

  void onPanEnd(DragEndDetails details) {
    if (dragX > maxDrag * 0.8) {
      widget.onAccept();
      animateTo(0);
    } else if (dragX < minDrag * 0.8) {
      widget.onDecline();
      animateTo(0);
    } else {
      animateTo(0);
    }
  }

  void animateTo(double to) {
    final start = dragX;
    anim = Tween<double>(begin: 0, end: 1).animate(animCtrl)
      ..addListener(() {
        setState(() {
          dragX = start + (anim.value) * (to - start);
        });
      });
    animCtrl
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final handleSize = widget.height - 12;
    maxDrag = (width / 2) - (handleSize / 2) - 8;
    minDrag = -maxDrag;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: Opacity(
              opacity: 1.0 - (dragX / maxDrag).clamp(0.0, 1.0),
              child: Text(
                widget.leftText,
                style: getTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            child: Opacity(
              opacity: 1.0 - ((-dragX) / maxDrag).clamp(0.0, 1.0),
              child: Text(
                widget.rightText,
                style: getTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            left: (width / 2) - (handleSize / 2) + dragX,
            child: GestureDetector(
              onPanStart: onPanStart,
              onPanUpdate: onPanUpdate,
              onPanEnd: onPanEnd,
              child: Container(
                width: handleSize,
                height: handleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(widget.iconPath, width: 24, height: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
