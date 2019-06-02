import 'package:flutter/material.dart';

import '../model.dart';
import 'article.dart';

/// Displays an article for the user to read.
///
/// If a landscape image is provided, it's displayed above the headline.
/// If a portrait image is provided, it's displayed below it.
class ArticleScreen extends StatefulWidget {
  ArticleScreen({
    @required this.key,
    @required this.article,
  })  : assert(key != null),
        assert(article != null);

  final Key key;
  final Article article;

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool isInitialized = false;
  bool isPreview = true;

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverChildListDelegate([
            ArticleView(
              key: widget.key,
              article: widget.article,
              isPreview: isPreview,
              duration: Duration(milliseconds: 200),
            ),
          ]),
        ],
      ),
    );

    if (!isInitialized) {
      isInitialized = true;
      Future.delayed(
        Duration(milliseconds: 100),
        () => setState(() => isPreview = false),
      );
    }

    return child;
  }
}

/*class ArticleView extends StatefulWidget {
  const ArticleView({@required this.article}) : assert(article != null);

  final Article article;

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  Widget build(BuildContext context) {
    if (widget.article.image == null) {
      return _buildWithoutImage();
    } else if (widget.article.image.size.aspectRatio >= 1) {
      return _buildWithLandscapeImage();
    } else {
      return _buildWithPortraitImage();
    }
  }

  Widget _buildWithoutImage() {
    var padding = Provider.of<ArticleTheme>(context).padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Section(child: Text(widget.article.section)),
        Headline(
          title: Text(widget.article.title),
          smallText: Text(widget.article.published.toString()),
        ),
        Transform.translate(
          offset: Offset(padding, -12),
          child: AuthorView(author: widget.article.author),
        ),
        Transform.translate(
          offset: Offset(0, -20),
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildWithLandscapeImage() {
    var padding = Provider.of<ArticleTheme>(context).padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Section(child: Text(widget.article.section)),
        Hero(
          tag: widget.article,
          child: ArticleImageView(image: widget.article.image),
        ),
        Transform.translate(
          offset: Offset(0, -48),
          child: Headline(
            title: Text(widget.article.title),
            smallText: Text(widget.article.published.toString()),
          ),
        ),
        Transform.translate(
          offset: Offset(padding, -61),
          child: AuthorView(author: widget.article.author),
        ),
        Transform.translate(
          offset: Offset(0, -48),
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildWithPortraitImage() {
    var padding = Provider.of<ArticleTheme>(context).padding;

    return Stack(
      children: <Widget>[
        Positioned(
          top: 180,
          right: 0,
          width: 220,
          child: _buildImage(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Section(child: Text(widget.article.section)),
            Headline(
              title: Text(widget.article.title),
              smallText: Text(widget.article.published.toString()),
            ),
            Transform.translate(
              offset: Offset(padding, -13.5),
              child: AuthorView(author: widget.article.author),
            ),
            SizedBox(height: 8),
            _buildContent(context),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    return widget.article == null
        ? ArticleImageView(image: null)
        : Hero(
            tag: widget.article,
            child: ArticleImageView(image: widget.article?.image),
          );
  }

  Widget _buildContent(BuildContext context) {
    var padding = Provider.of<ArticleTheme>(context).padding;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 16),
      child: Text(
        widget.article.content,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.justify,
      ),
    );
  }
}*/
