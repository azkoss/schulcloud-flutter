import 'package:flutter/material.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:provider/provider.dart';
import 'package:schulcloud/app/services/user_fetcher.dart';

import '../data.dart';
import 'article_image.dart';
import 'author.dart';
import 'headline.dart';
import 'section.dart';
import 'theme.dart';

/// Displays an article for the user to read.
///
/// If a landscape image is provided, it's displayed above the headline.
/// If a portrait image is provided, it's displayed below it.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({@required this.article}) : assert(article != null);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final width = constraints.maxWidth;
          final double margin = width < 500 ? 0 : width * 0.08;
          final double padding = (width * 0.06).clamp(32.0, 64.0);

          return Provider<ArticleTheme>(
            builder: (_) =>
                ArticleTheme(darkColor: Colors.purple, padding: padding),
            child: ListView(
              padding: MediaQuery.of(context).padding +
                  EdgeInsets.symmetric(horizontal: margin) +
                  EdgeInsets.symmetric(vertical: 16),
              children: <Widget>[
                ArticleView(article: article),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ArticleView extends StatefulWidget {
  const ArticleView({@required this.article}) : assert(article != null);

  final Article article;

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  Widget build(BuildContext context) {
    if (widget.article.imageUrl == null) {
      return _buildWithoutImage();
    } else {
      return _buildWithLandscapeImage();
    }
  }

  Widget _buildWithoutImage() {
    final padding = Provider.of<ArticleTheme>(context).padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Section(child: Text('Section')),
        HeadlineBox(
          title: Text(widget.article.title),
          smallText: Text(widget.article.published.toString()),
        ),
        Transform.translate(
          offset: Offset(padding, -12),
          child: _buildAuthorView(context),
        ),
        Transform.translate(
          offset: Offset(0, -20),
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildWithLandscapeImage() {
    final padding = Provider.of<ArticleTheme>(context).padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Section(child: Text('Section')),
        Hero(
          tag: widget.article,
          child: ArticleImageView(imageUrl: widget.article.imageUrl),
        ),
        Transform.translate(
          offset: Offset(0, -48),
          child: HeadlineBox(
            title: Text(widget.article.title),
            smallText: Text(widget.article.published.toString()),
          ),
        ),
        Transform.translate(
          offset: Offset(padding, -61),
          child: _buildAuthorView(context),
        ),
        Transform.translate(
          offset: Offset(0, -48),
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildAuthorView(BuildContext context) {
    return CachedRawBuilder(
      controller: UserFetcherService.of(context)
          .fetchUser(widget.article.author, widget.article.id),
      builder: (_, update) {
        return AuthorView(author: update.data);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final padding = Provider.of<ArticleTheme>(context).padding;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 16),
      child: Text(
        widget.article.content,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
