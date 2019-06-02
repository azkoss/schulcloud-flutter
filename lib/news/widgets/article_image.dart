import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model.dart';

/// Displays an article image, which is faded in as its loaded.
///
/// If the [image] is [null], a placeholder is displayed.
class ArticleImageView extends StatelessWidget {
  const ArticleImageView({
    @required this.image,
    @required this.isPreview,
    @required this.color,
    @required this.duration,
  }) : assert(color != null);

  final ArticleImage image;
  final bool isPreview;
  final Color color;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isPreview
          ? BorderRadius.only(
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            )
          : BorderRadius.zero,
      child: Stack(
        children: <Widget>[
          _buildAnimatedImage(),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: duration,
              opacity: isPreview ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withOpacity(0.9),
                      color.withOpacity(0),
                      color.withOpacity(0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        double height = image == null ? 0 : width / image.size.aspectRatio;

        return AnimatedContainer(
          duration: duration,
          width: double.infinity,
          color: color,
          child: image == null
              ? null
              : AspectRatio(
                  aspectRatio: image.size.aspectRatio,
                  child: _buildImage(),
                ),
        );
      },
    );
  }

  Widget _buildImage() {
    return FadeInImage.memoryNetwork(
      fadeInDuration: duration,
      fadeInCurve: Curves.easeInOutCubic,
      placeholder: kTransparentImage,
      image: image.url,
      fit: BoxFit.fitWidth,
    );
  }
}
