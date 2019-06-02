import 'package:flutter/material.dart';
import 'package:schulcloud/utils/text_or_placeholder.dart';

import '../model.dart';
import 'article_image.dart';
import 'article_screen.dart';
import 'author.dart';
import 'headline.dart';
import 'section.dart';

const _darkColor = const Color(0xff440e32);
const _lightColor = const Color(0xff58216b);

class ArticleView extends StatefulWidget {
  ArticleView({
    Key key,
    @required this.article,
    this.isPreview = false,
    this.duration = const Duration(milliseconds: 200),
  })  : this.key = key,
        super(key: key);

  final Key key;
  final Article article;
  final bool isPreview;
  final Duration duration;

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  Article get article => widget.article;
  bool get isPreview => widget.isPreview;
  Duration get duration => widget.duration;
  bool get hasLandscapeImage => (article?.image?.size?.aspectRatio ?? 0) > 1;
  bool get hasPortraitImage => (article?.image?.size?.aspectRatio ?? 2) < 1;

  void _onTap() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) =>
          ArticleScreen(key: widget.key, article: article),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(tag: widget.key, child: _buildArticleCard()),
        if (isPreview) Positioned.fill(child: _buildTapTarget()),
      ],
    );
  }

  Widget _buildArticleCard() {
    return Material(
      animationDuration: duration,
      elevation: 2,
      borderRadius: BorderRadius.circular(isPreview ? 8 : 0),
      color: Colors.white,
      child: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            var width = constraints.maxWidth;
            double margin = isPreview ? 16 : (width < 500 ? 0 : width * 0.08);
            double padding = (width * 0.06).clamp(32.0, 64.0);

            return AnimatedContainer(
              duration: duration,
              padding: EdgeInsets.all(margin),
              child: Wrap(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSection(padding),
                      _buildImage(),
                      _buildHeadline(padding),
                      _buildAuthor(padding),
                      _buildContent(padding),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(double padding) {
    return Section(
      duration: duration,
      paddingLeft: isPreview ? 16 : padding,
      lightColor: _lightColor,
      darkColor: _darkColor,
      child: TextOrPlaceholder(
        article?.section,
        maxWidthFraction: 0.3,
        color: Colors.white,
      ),
    );
  }

  Widget _buildImage() {
    return ArticleImageView(
      image: article?.image,
      isPreview: isPreview,
      color: _lightColor,
      duration: duration,
    );
  }

  Widget _buildHeadline(double padding) {
    return AnimatedContainer(
      duration: duration,
      transform: Matrix4.translationValues(0, isPreview ? 0 : -48, 0),
      child: Headline(
        isPreview: isPreview,
        title: TextOrPlaceholder(
          article?.title,
          color: isPreview ? Colors.black12 : Colors.white,
          numLines: 2,
        ),
        smallText: TextOrPlaceholder(
          article == null ? null : 'vor 3 Tagen von ${article?.author?.name}',
          color: isPreview ? Colors.black12 : Colors.white,
        ),
        padding: padding,
        lightColor: _lightColor,
        darkColor: _darkColor,
        duration: duration,
      ),
    );
  }

  Widget _buildAuthor(double padding) {
    return Wrap(
      children: <Widget>[
        AnimatedContainer(
          duration: duration,
          height: isPreview ? 0 : 48,
          transform:
              Matrix4.translationValues(padding, isPreview ? 0 : -57.5, 0),
          child: AuthorView(author: article?.author),
        ),
      ],
    );
  }

  Widget _buildContent(double padding) {
    final style = Theme.of(context).textTheme.body2.copyWith(fontSize: 16);
    final text = isPreview && (article?.content?.length ?? 0) > 200
        ? '${article.content.substring(0, 200)}...'
        : article?.content;

    return AnimatedContainer(
      duration: duration,
      padding: isPreview
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: padding),
      transform: Matrix4.translationValues(0, isPreview ? 0 : -48, 0),
      child: TextOrPlaceholder(text, style: style, numLines: 5),
    );
  }

  Widget _buildTapTarget() {
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        highlightColor: Colors.black.withOpacity(0.08),
        splashColor: Colors.black.withOpacity(0.1),
        onTap: article == null ? () {} : _onTap,
      ),
    );
  }
}
