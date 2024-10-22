import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String course;
  final String staff;
  final String sub1;
  final String sub2;
  final String day1;
  final String day2;

  Course({
    required this.id,
    required this.course,
    required this.staff,
    required this.sub1,
    required this.sub2,
    required this.day1,
    required this.day2,
  });

  factory Course.fromDocument(DocumentSnapshot doc) {
    return Course(
      id: doc.id,
      course: doc['course'],
      staff: doc['staff'],
      sub1: doc['sub1'],
      sub2: doc['sub2'],
      day1: doc['day1'],
      day2: doc['day2'],
    );
  }
}
