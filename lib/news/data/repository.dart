import 'package:schulcloud/core/data.dart';
import 'package:schulcloud/core/storage.dart';

import 'author.dart';
import 'article.dart';

class AuthorRepository extends CachedStorage<AuthorDto> {
  AuthorRepository()
      : super(
          id: 'news_authors',
          source: AuthorDownloader(),
          serializer: AuthorDtoSerializer(),
        );
}

class AuthorDownloader extends Repository<AuthorDto> {
  @override
  Stream<AuthorDto> fetch(Id<AuthorDto> id) {
    return Stream.fromFuture(() async {
      await Future.delayed(Duration(seconds: 1));
      if (id.id == 'marcel') {
        return AuthorDto(id: id, name: 'Marcel Garus');
      } else {
        return AuthorDto(
          id: id,
          name: 'Mona Weitzenberg',
          photoUrl: 'https://schul-cloud.org/images/team/Mona.png',
        );
      }
    }());
  }
}

class ArticleRepository extends CachedStorage<ArticleDto> {
  ArticleRepository()
      : super(
          id: 'news_articles',
          source: ArticleDownloader(),
          serializer: ArticleDtoSerializer(),
        );
}

class ArticleDownloader extends Repository<ArticleDto> {
  @override
  Stream<ArticleDto> fetch(Id<ArticleDto> id) {
    // TODO: Here, the actual download should happen.
    return Stream.fromFuture(() async {
      await Future.delayed(Duration(seconds: 1));
      int index = int.parse(id.id.substring('article_'.length));
      if (index.isEven) {
        return ArticleDto(
          id: Id('article_${index}_mona'),
          title: 'Headline lorem ipsum dolor',
          author: const Id('mona'),
          published: DateTime.now().subtract(Duration(days: 3)),
          section: 'News Schultheater',
          imageUrl:
              'https://cdn.stockphotosecrets.com/wp-content/uploads/2018/09/stock-photo-meme.jpg',
          content:
              '''Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.

    Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien.

    Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestibulum volutpat pretium libero. Cras id dui. Aenean ut eros et nisl sagittis vestibulum. Nullam nulla eros, ultricies sit amet, nonummy id, imperdiet feugiat, pede. Sed lectus. Donec mollis hendrerit risus. Phasellus nec sem in justo pellentesque facilisis. Etiam imperdiet imperdiet orci. Nunc nec neque. Phasellus leo dolor, tempus non, auctor et, hendrerit quis, nisi. Curabitur ligula sapien, tincidunt non, euismod vitae, posuere imperdiet, leo. Maecenas malesuada. Praesent congue erat at massa. Sed cursus turpis vitae tortor. Donec posuere vulputate arcu. Phasellus accumsan cursus velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed aliquam, nisi quis porttitor congue, elit erat euismod orci, ac''',
        );
      } else {
        return ArticleDto(
          id: Id('article_${index}_marcel'),
          title: 'Beispielartikel ohne Bild',
          author: const Id('marcel'),
          published: DateTime.now().subtract(Duration(days: 2)),
          section: 'News Dingsbums',
          content: 'Ein ganz kurzer Beispieltext.',
        );
      }
    }());
  }
}
