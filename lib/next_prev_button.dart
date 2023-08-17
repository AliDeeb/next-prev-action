import 'package:flutter/material.dart';

class NextPrevButton extends StatefulWidget {
  const NextPrevButton({
    super.key,
    required this.width,
    required this.height,
    this.color = const Color.fromARGB(255, 6, 91, 219),
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 25),
    this.onPrevTap,
    this.onNextTap,
  });

  final double width;
  final double height;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPrevTap;
  final VoidCallback? onNextTap;

  @override
  State<NextPrevButton> createState() => _NextPrevButtonState();
}

class _NextPrevButtonState extends State<NextPrevButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotateX;
  late Animation<double> rotateY;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    rotateX = Tween<double>(begin: 0, end: 0).animate(controller);
    rotateY = Tween<double>(begin: 0, end: 0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(rotateX.value)
            ..rotateY(rotateY.value),
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              color: widget.color?.withOpacity(.5) ?? Colors.transparent,
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white60,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            onTapDown: (details) {
              if (controller.isAnimating) return;

              final clickPostion = details.localPosition;

              if (clickPostion.dy >= widget.height / 2) {
                rotateX = Tween<double>(
                  begin: 0,
                  end: clickPostion.dy * 0.001,
                ).animate(controller);
              } else {
                rotateX = Tween<double>(
                  begin: 0,
                  end: (widget.height - clickPostion.dy) * -0.001,
                ).animate(controller);
              }

              if (clickPostion.dx >= widget.width / 2) {
                rotateY = Tween<double>(
                  begin: 0,
                  end: clickPostion.dx * -0.0015,
                ).animate(controller);
                widget.onNextTap?.call();
              } else {
                rotateY = Tween<double>(
                  begin: 0,
                  end: (widget.width - clickPostion.dx) * 0.0015,
                ).animate(controller);
                widget.onPrevTap?.call();
              }
              controller.forward().then((value) {
                controller.reverse();
              });
            },
            child: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white),
                  SizedBox(
                      height: 30, child: VerticalDivider(color: Colors.black)),
                  Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
