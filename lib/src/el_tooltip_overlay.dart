import 'package:el_tooltip/el_tooltip.dart';
import 'package:el_tooltip/src/arrow.dart';
import 'package:el_tooltip/src/bubble.dart';
import 'package:el_tooltip/src/element_box.dart';
import 'package:el_tooltip/src/modal.dart';
import 'package:el_tooltip/src/tooltip_elements_display.dart';
import 'package:flutter/material.dart';

class ElTooltipOverlay extends StatefulWidget {
  const ElTooltipOverlay({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14.0),
    this.showModal = true,
    this.showArrow = true,
    this.showChildAboveOverlay = true,
    this.modalConfiguration = const ModalConfiguration(),
    required this.toolTipElementsDisplay,
    required this.color,
    required this.content,
    required this.hideOverlay,
    required this.triggerBox,
    required this.arrowBox,
    required this.appearAnimationDuration,
    required this.disappearAnimationDuration,
  });

  final Widget child;
  final Color color;
  final Widget content;
  final EdgeInsetsGeometry padding;
  final bool showModal;
  final bool showArrow;
  final bool showChildAboveOverlay;
  final ModalConfiguration modalConfiguration;
  final ToolTipElementsDisplay toolTipElementsDisplay;
  final VoidCallback hideOverlay;
  final ElementBox triggerBox;
  final ElementBox arrowBox;
  final Duration appearAnimationDuration;
  final Duration disappearAnimationDuration;

  @override
  State<ElTooltipOverlay> createState() => ElTooltipOverlayState();
}

class ElTooltipOverlayState extends State<ElTooltipOverlay> {
  bool closing = false;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => show());
  }

  Future<void> show() async {
    setState(() {
      closing = false;
      opacity = 1;
    });
    await Future.delayed(widget.appearAnimationDuration);
  }

  Future<void> hide() async {
    setState(() {
      closing = true;
      opacity = 0;
    });
    await Future.delayed(widget.disappearAnimationDuration);
  }

  @override
  Widget build(BuildContext context) {
    // Determine the x-offset based on the position
    double bubbleXOffset = widget.toolTipElementsDisplay.bubble.x;
    double arrowXOffset = widget.toolTipElementsDisplay.arrow.x;

    // Adjust offsets based on the tooltip position
    switch (widget.toolTipElementsDisplay.position) {
      case ElTooltipPosition.topStart:
        bubbleXOffset -= 15;
        arrowXOffset -= 15;
        break;
      case ElTooltipPosition.bottomStart:
        bubbleXOffset -= 9;
        arrowXOffset -= 9;
        break;
      case ElTooltipPosition.topEnd:
      case ElTooltipPosition.bottomEnd:
        bubbleXOffset += 15;
        arrowXOffset += 15;
        break;
      default:
      // No additional offset for other positions
        break;
    }

    return AnimatedOpacity(
      opacity: opacity,
      duration: closing
          ? widget.disappearAnimationDuration
          : widget.appearAnimationDuration,
      child: Stack(
        children: [
          Modal(
            color: widget.modalConfiguration.color,
            opacity: widget.modalConfiguration.opacity,
            visible: widget.showModal,
            onTap: widget.hideOverlay,
          ),
          Positioned(
            top: widget.toolTipElementsDisplay.bubble.y,
            left: bubbleXOffset,
            child: Bubble(
              triggerBox: widget.triggerBox,
              padding: widget.padding,
              radius: widget.toolTipElementsDisplay.radius,
              color: widget.color,
              child: widget.content,
            ),
          ),
          if (widget.showArrow)
            Positioned(
              top: widget.toolTipElementsDisplay.arrow.y,
              left: arrowXOffset,
              child: Arrow(
                color: widget.color,
                position: widget.toolTipElementsDisplay.position,
                width: widget.arrowBox.w,
                height: widget.arrowBox.h,
              ),
            ),
          if (widget.showChildAboveOverlay)
            Positioned(
              top: widget.triggerBox.y,
              left: widget.triggerBox.x,
              child: GestureDetector(
                onTap: widget.hideOverlay,
                child: widget.child,
              ),
            ),
        ],
      ),
    );
  }
}
