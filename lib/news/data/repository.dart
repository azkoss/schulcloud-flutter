import 'package:flutter/foundation.dart';
import 'package:schulcloud/app/services.dart';
import 'package:schulcloud/core/data.dart';
import 'package:sqflite/sqflite.dart';

import 'article.dart';

class ArticleDownloader extends Repository<Article> {
  ApiService api;
  List<Article> _articles;
  Future<void> _downloader;

  ArticleDownloader({@required this.api})
      : super(isFinite: true, isMutable: false) {
    _downloader = _loadArticles();
  }

  Future<void> _loadArticles() async {
    _articles = await api.listNews();
    print(_articles);
  }

  @override
  Stream<List<RepositoryEntry<Article>>> fetchAllEntries() async* {
    if (_articles == null) await _downloader;
    yield _articles
        .map((a) => RepositoryEntry(
              id: a.id,
              item: a,
            ))
        .toList();
  }

  @override
  Stream<Article> fetch(Id<Article> id) async* {
    if (_articles != null) yield _articles.firstWhere((a) => a.id == id);
  }
}

class ArticleDao extends BaseDao<Article> {
  @override
  Stream<Article> fetch(Id<Article> id) async* {
    final Database db = await databaseProvider.database;
    List<Map<String, dynamic>> articleJsons;
    Map<String, dynamic> authorJson;

    await db.transaction((txn) async {
      articleJsons = await txn.query(databaseProvider.tableArticle,
          where: 'id = ?', whereArgs: [id.toString()]);
      authorJson = await _getAuthorJsonForArticle(id, txn);
    });

    if (articleJsons.isEmpty) {
      yield null;
      return;
    }
    Map<String, dynamic> articleJson = articleJsons.first;
    articleJson = _addAuthorJson(articleJson, authorJson);
    yield Article.fromJson(articleJson);
  }

  @override
  Stream<List<RepositoryEntry<Article>>> fetchAllEntries() async* {
    final Database db = await databaseProvider.database;
    List<Map<String, dynamic>> articleJsons;
    List<Map<String, dynamic>> authorJsons;
    await db.transaction((txn) async {
      articleJsons = await txn.query(databaseProvider.tableArticle,
          orderBy: 'published DESC');
      authorJsons = await _getAuthorJsonsForArticles(txn);
    });

    List<RepositoryEntry<Article>> articleEntries =
        articleJsons.map((articleJson) {
      Map<String, dynamic> authorJsonForArticle = authorJsons
          .firstWhere((json) => json['id'] == articleJson['authorId']);

      articleJson = _addAuthorJson(articleJson, authorJsonForArticle);
      Article article = Article.fromJson(articleJson);

      return RepositoryEntry(id: article.id, item: article);
    }).toList();

    yield articleEntries;
  }

  @override
  Future<void> update(Id<Article> id, Article article) async {
    final Database db = await databaseProvider.database;
    await db.transaction((txn) async {
      await _deleteObsoleteAuthorForArticle(article, txn);
      await _updateAuthorForArticle(article, txn);
      await txn.insert(databaseProvider.tableArticle, article.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  @override
  Future<void> remove(Id<Article> id) async {
    final Database db = await databaseProvider.database;
    await db.transaction((txn) async {
      await txn.delete(databaseProvider.tableArticle,
          where: 'id = ?', whereArgs: [id.toString()]);
      await _deleteAuthorForArticle(id, txn);
    });
  }

  @override
  Future<void> clear() async {
    final Database db = await databaseProvider.database;
    await db.transaction((txn) async {
      await txn.delete(databaseProvider.tableArticle);
      await txn.delete(databaseProvider.tableAuthor);
    });
  }

  Map<String, dynamic> _addAuthorJson(
      Map<String, dynamic> articleJson, Map<String, dynamic> authorJson) {
    Map<String, dynamic> modifiableArticleJson =
        Map<String, dynamic>.from(articleJson);
    modifiableArticleJson.putIfAbsent('author', () => authorJson);
    return modifiableArticleJson;
  }

  Future<Map<String, dynamic>> _getAuthorJsonForArticle(
      Id<Article> id, Transaction txn) async {
    final List<Map<String, dynamic>> authorJsons = await txn.rawQuery(
        '''SELECT DISTINCT aut.id as id, aut.name as name, aut.photoUrl as photoUrl
           FROM (SELECT authorId
                  FROM ${databaseProvider.tableArticle}
                  WHERE id = ?) articleAuthor
            INNER JOIN ${databaseProvider.tableAuthor} aut
              ON articleAuthor.authorId = aut.id''', ['${id.toString()}']);

    if (authorJsons.isEmpty) {
      return null;
    }
    return authorJsons.first;
  }

  Future<List<Map<String, dynamic>>> _getAuthorJsonsForArticles(
      Transaction txn) async {
    final List<Map<String, dynamic>> authorJsons = await txn.rawQuery(
        '''SELECT DISTINCT aut.id as id, aut.name as name, aut.photoUrl as photoUrl
           FROM (SELECT authorId 
                 FROM ${databaseProvider.tableArticle}) articleAuthor
            INNER JOIN ${databaseProvider.tableAuthor} aut
              ON articleAuthor.authorId = aut.id''');

    if (authorJsons.isEmpty) {
      return null;
    }
    return authorJsons;
  }

  Future<void> _updateAuthorForArticle(Article article, Transaction txn) async {
    await txn.insert(databaseProvider.tableAuthor, article.author.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _deleteAuthorForArticle(Id<Article> id, Transaction txn) async {
    await txn.rawDelete('''DELETE FROM ${databaseProvider.tableAuthor}
                    WHERE id IN (
                      SELECT authorId
                      FROM ${databaseProvider.tableArticle}
                      WHERE id = ?)''', ['${id.toString()}']);
  }

  Future<void> _deleteObsoleteAuthorForArticle(
      Article article, Transaction txn) async {
    await txn.rawDelete('''DELETE FROM ${databaseProvider.tableAuthor}
                    WHERE id IN (
                      SELECT authorId
                      FROM ${databaseProvider.tableArticle}
                      WHERE id = ? AND authorId <> ?)''',
        ['${article.id.id}', '${article.authorId}']);
  }
}