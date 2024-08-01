import 'package:flutter/material.dart';
import 'element_box.dart';

/// Bubble serves as the tooltip container
class Bubble extends StatefulWidget {
  final Color color;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final ElementBox triggerBox;
  final BorderRadiusGeometry? radius;
  final Widget child;
  final double minWidth;
  final double minHeight;
  final List<BoxShadow>? boxShadow;

  const Bubble({
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(10.0),
    this.radius = const BorderRadius.all(Radius.circular(0)),
    required this.child,
    required this.triggerBox,
    this.maxWidth = 300.0,
    this.minWidth = 160.0, // Set default minWidth
    this.minHeight = 44.0, // Set default minHeight
    this.boxShadow,
    super.key,
  });

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: 1.0,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: widget.maxWidth,
              minWidth: widget.minWidth,
              minHeight: widget.minHeight,
              maxHeight: 68
          ),
          decoration: BoxDecoration(
            borderRadius: widget.radius,
            color: widget.color,
            boxShadow: widget.boxShadow ?? const [
              BoxShadow(
                color: Color(0x26121620),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}