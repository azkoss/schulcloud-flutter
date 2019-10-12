import 'dart:convert';

import 'package:cached_listview/cached_listview.dart';
import 'package:meta/meta.dart';
import 'package:schulcloud/app/app.dart';

import 'data.dart';

class Bloc {
  NetworkService network;
  CacheController<Course> courses;

  Bloc({@required NetworkService network})
      : assert(network != null),
        this.network = network,
        courses = HiveCacheController<Course>(
          name: 'courses',
          fetcher: () async {
            var response = await network.get('courses');
            var body = json.decode(response.body);

            return [
              for (var data in body['data'] as List<dynamic>)
                Course(
                  id: Id(data['_id']),
                  name: data['name'],
                  description: data['description'],
                  teachers: [
                    for (String id in data['teacherIds'])
                      await fetchUser(network, Id(id)),
                  ],
                  color: hexStringToColor(data['color']),
                ),
            ];
          },
        );

  void dispose() => courses.dispose();

  CacheController<Lesson> getLessonsOfCourse(Id courseId) =>
      HiveCacheController(
        name: 'lessons',
        fetcher: () async {
          var response = await network.get('lessons?courseId=$courseId');
          var body = json.decode(response.body);

          return [
            for (var data in body['data'] as List<dynamic>)
              Lesson(
                id: Id(data['_id']),
                name: data['name'],
                contents: (data['contents'] as List<dynamic>)
                    .map((content) => _createContent(content))
                    .where((c) => c != null)
                    .toList(),
              ),
          ];
        },
      );

  static Content _createContent(Map<String, dynamic> data) {
    ContentType type;
    switch (data['component']) {
      case 'text':
        type = ContentType.text;
        break;
      case 'Etherpad':
        type = ContentType.etherpad;
        break;
      case 'neXboard':
        type = ContentType.nexboad;
        break;
      default:
        return null;
    }
    return Content(
      id: Id(data['_id']),
      title: data['title'] != '' ? data['title'] : 'Ohne Titel',
      type: type,
      text: type == ContentType.text ? data['content']['text'] : null,
      url: type != ContentType.text ? data['content']['url'] : null,
    );
  }
}
