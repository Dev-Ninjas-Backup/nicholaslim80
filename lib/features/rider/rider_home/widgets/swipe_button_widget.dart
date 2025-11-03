import 'package:flutter/material.dart';

class SwipeButtonWidget extends StatefulWidget {
  final String leftText;
  final String rightText;
  final Color backgroundColor;
  final double height;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const SwipeButtonWidget({
    super.key,
    required this.leftText,
    required this.rightText,
    required this.backgroundColor,
    this.height = 60,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<SwipeButtonWidget> createState() => _SwipeButtonWidgetState();
}

class _SwipeButtonWidgetState extends State<SwipeButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _anim;
  double _dragX = 0.0;
  double _maxDrag = 0.0;
  double _minDrag = 0.0;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _animCtrl.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragX += details.delta.dx;
      _dragX = _dragX.clamp(_minDrag, _maxDrag);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragX > _maxDrag * 0.8) {
      // Swiped Right → Accept
      widget.onAccept();
      _animateTo(0);
    } else if (_dragX < _minDrag * 0.8) {
      // Swiped Left → Decline
      widget.onDecline();
      _animateTo(0);
    } else {
      // Return to center
      _animateTo(0);
    }
  }

  void _animateTo(double to) {
    final start = _dragX;
    _anim = Tween<double>(begin: 0, end: 1).animate(_animCtrl)
      ..addListener(() {
        setState(() {
          _dragX = start + (_anim.value) * (to - start);
        });
      });
    _animCtrl
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width - 32; // adjust for card padding
    final handleSize = widget.height - 12;
    _maxDrag = (width / 2) - (handleSize / 2) - 8;
    _minDrag = -_maxDrag;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left label
          Positioned(
            left: 16,
            child: Opacity(
              opacity: 1.0 - (_dragX / _maxDrag).clamp(0.0, 1.0),
              child: Text(
                widget.leftText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Right label
          Positioned(
            right: 16,
            child: Opacity(
              opacity: 1.0 - ((-_dragX) / _maxDrag).clamp(0.0, 1.0),
              child: Text(
                widget.rightText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Draggable handle
          Positioned(
            left: (width / 2) - (handleSize / 2) + _dragX,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                width: handleSize,
                height: handleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.directions_car, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
