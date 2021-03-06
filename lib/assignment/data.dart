import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:schulcloud/app/app.dart';
import 'package:schulcloud/course/course.dart';

part 'data.g.dart';

@immutable
@HiveType()
class Assignment implements Entity, Comparable {
  const Assignment({
    @required this.id,
    @required this.name,
    @required this.schoolId,
    @required this.dueDate,
    @required this.availableDate,
    @required this.teacherId,
    this.description,
    this.courseId,
    this.lessonId,
    this.isPrivate,
  })  : assert(id != null),
        assert(name != null),
        assert(schoolId != null),
        assert(dueDate != null),
        assert(availableDate != null),
        assert(teacherId != null);

  Assignment.fromJson(Map<String, dynamic> data)
      : this(
          id: Id(data['_id']),
          schoolId: data['schoolId'],
          teacherId: data['teacherId'],
          name: data['name'],
          description: data['description'],
          availableDate:
              DateTime.tryParse(data['availableDate']) ?? DateTime.now(),
          dueDate: DateTime.parse(data['dueDate']),
          courseId: Id<Course>(data['courseId']['_id']),
          lessonId: Id(data['lessonId'] ?? ''),
          isPrivate: data['private'],
        );

  @override
  @HiveField(0)
  final Id<Assignment> id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String schoolId;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final DateTime availableDate;

  @HiveField(5)
  final String description;

  @HiveField(8)
  final String teacherId;

  @HiveField(9)
  final Id<Course> courseId;

  @HiveField(10)
  final Id<Lesson> lessonId;

  @HiveField(11)
  final bool isPrivate;

  @override
  int compareTo(Object other) {
    return dueDate.compareTo((other as Assignment).dueDate);
  }
}

@immutable
@HiveType()
class Submission implements Entity {
  const Submission({
    @required this.id,
    @required this.schoolId,
    @required this.assignmentId,
    @required this.studentId,
    this.comment,
    this.grade,
    this.gradeComment,
  })  : assert(id != null),
        assert(schoolId != null),
        assert(assignmentId != null),
        assert(studentId != null);

  Submission.fromJson(Map<String, dynamic> data)
      : this(
          id: Id(data['_id']),
          schoolId: data['schoolId'],
          assignmentId: Id(data['homeworkId']),
          studentId: Id(data['studentId']),
          comment: data['comment'],
          grade: data['grade'],
          gradeComment: data['gradeComment'],
        );

  @override
  @HiveField(0)
  final Id<Submission> id;

  @HiveField(1)
  final String schoolId;

  @HiveField(2)
  final Id<Assignment> assignmentId;

  @HiveField(3)
  final Id<User> studentId;

  @HiveField(6)
  final String comment;

  @HiveField(7)
  final int grade;

  @HiveField(8)
  final String gradeComment;
}
