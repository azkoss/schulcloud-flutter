import 'dart:math';

import 'package:flutter/material.dart';

class TextOrPlaceholder extends StatefulWidget {
  const TextOrPlaceholder(
    this.text, {
    Key key,
    this.style,
    this.textAlign = TextAlign.left,
    this.numLines = 1,
    this.maxWidthFraction = 1,
    this.color = Colors.black12,
    this.lineSpacing = 8,
  })  : assert(textAlign != null),
        assert(numLines != null),
        assert(color != null),
        assert(lineSpacing != null),
        super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int numLines;
  final double maxWidthFraction;
  final Color color;
  final double lineSpacing;

  @override
  _TextOrPlaceholderState createState() => _TextOrPlaceholderState();
}

class _TextOrPlaceholderState extends State<TextOrPlaceholder> {
  double randomWidth;
  bool get isPlaceholder => widget.text == null;

  @override
  Widget build(BuildContext context) {
    var effectiveStyle = widget.style;
    if (widget.style == null || widget.style.inherit)
      effectiveStyle = DefaultTextStyle.of(context).style.merge(effectiveStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        Size size;
        randomWidth ??= (0.2 + 0.7 * Random().nextDouble()) *
            constraints.maxWidth *
            widget.maxWidthFraction;

        if (widget.text != null) {
          var span = TextSpan(text: widget.text, style: effectiveStyle);
          var tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          tp.layout(maxWidth: constraints.maxWidth);
          size = tp.size;
        } else {
          var spacing = widget.lineSpacing;
          size = Size(
            widget.numLines == 1 ? randomWidth : constraints.maxWidth,
            widget.numLines * ((effectiveStyle.fontSize ?? 14) + spacing) -
                spacing,
          );
        }

        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: size.width,
          height: size.height,
          child: _buildContent(effectiveStyle),
        );
      },
    );
  }

  Widget _buildContent(TextStyle style) {
    return Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: isPlaceholder ? 1 : 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.numLines * 2 - 1, (i) {
                return i.isOdd
                    ? SizedBox(height: widget.lineSpacing)
                    : _PlaceholderBar(
                        width: i < (widget.numLines - 1) * 2
                            ? double.infinity
                            : randomWidth,
                        height: style.fontSize,
                        color: widget.color,
                      );
              }),
            ),
          ),
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: isPlaceholder ? 0 : 1,
          child: Text(widget.text ?? '', style: style),
        ),
      ],
    );
  }
}

class _PlaceholderBar extends StatelessWidget {
  const _PlaceholderBar({
    @required this.width,
    @required this.height,
    @required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: StadiumBorder(),
      color: color,
      child: SizedBox(width: width, height: height),
    );
  }
}
