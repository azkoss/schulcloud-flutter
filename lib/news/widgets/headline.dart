import 'package:flutter/material.dart';

import 'theme.dart';

/// A headline and some small text in a colored box.
///
/// The colors and padding come from the enclosing [ArticleTheme].
class Headline extends StatelessWidget {
  const Headline({
    @required this.isPreview,
    @required this.title,
    @required this.smallText,
    @required this.padding,
    @required this.lightColor,
    @required this.darkColor,
    @required this.duration,
  })  : assert(title != null),
        assert(smallText != null);

  final bool isPreview;
  final Widget title;
  final Widget smallText;
  final double padding;
  final Color lightColor;
  final Color darkColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    var insidePadding = isPreview
        ? EdgeInsets.only(top: 8)
        : EdgeInsets.fromLTRB(padding, 32, 32, 32);

    var gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        darkColor.withOpacity(isPreview ? 0 : 1),
        lightColor.withOpacity(isPreview ? 0 : 1),
      ],
    );

    var width = MediaQuery.of(context).size.width - padding;

    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        child: Container(
          decoration: BoxDecoration(gradient: gradient),
          padding: insidePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSmallText(context),
              SizedBox(height: isPreview ? 0 : 8),
              _buildTitle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    var style = Theme.of(context).textTheme.display2;
    if (!isPreview) style = style.copyWith(color: Colors.white);

    return AnimatedDefaultTextStyle(
      duration: duration,
      style: style,
      child: title,
    );
  }

  Widget _buildSmallText(BuildContext context) {
    var style = Theme.of(context).textTheme.body1.copyWith(
          color: isPreview ? null : Colors.white,
        );

    return AnimatedDefaultTextStyle(
      duration: duration,
      style: style,
      child: smallText,
    );
  }
}
