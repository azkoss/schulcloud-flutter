import 'package:flutter/material.dart';

/// A section banner that is usually displayed at the top of an article.
class Section extends StatelessWidget {
  const Section({
    @required this.paddingLeft,
    @required this.lightColor,
    @required this.darkColor,
    @required this.child,
    @required this.duration,
  }) : assert(child != null);

  final double paddingLeft;
  final Color lightColor;
  final Color darkColor;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SectionClipper(),
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [lightColor, darkColor],
          ),
        ),
        padding: EdgeInsets.fromLTRB(paddingLeft, 8, 16, 8),
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style.apply(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}

/// A custom clipper that clips the typical section shape.
class _SectionClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    var cutIn = 0.4 * size.shortestSide;
    var controlPoint = width - 0.8 * cutIn;
    return Path()
      ..lineTo(width - cutIn, 0)
      ..cubicTo(
          controlPoint, 0, controlPoint, 0, width - 0.6 * cutIn, 0.2 * height)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
  }

  @override
  bool shouldReclip(_SectionClipper oldClipper) => true;
}
