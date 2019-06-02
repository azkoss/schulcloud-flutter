import 'package:flutter/material.dart';

class MaybeHero extends StatelessWidget {
  MaybeHero({
    @required this.enable,
    @required this.tag,
    @required this.child,
  });

  final bool enable;
  final Object tag;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      enable ? Hero(tag: tag, child: child) : child;
}
