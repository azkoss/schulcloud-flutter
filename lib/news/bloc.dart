import '../paginated_loader.dart';
import 'model.dart';

export 'model.dart';

class Bloc {
  final _loader = PaginatedLoader<Article>(
    itemsPerPage: 10,
    pageLoader: _loadPage,
  );

  static Future<List<Article>> _loadPage(int page) async {
    return List.generate(10, (i) {
      return Article(
        title: 'Headline lorem ipsum dolor',
        author: 'Mona Weitzenberg',
        published: DateTime.now().subtract(Duration(days: 3)),
        bannerText: 'News Schultheater',
        photoUrl:
            'https://cdn.stockphotosecrets.com/wp-content/uploads/2018/09/stock-photo-meme.jpg',
        content: 'Lorem ipsum dolor sit amet, consetetur',
      );
    });
  }

  Future<Article> getArticleAtIndex(int index) => _loader.getItem(index);
  void refresh() => _loader.clearCache();
}
