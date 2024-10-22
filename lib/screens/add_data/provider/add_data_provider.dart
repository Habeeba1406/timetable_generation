import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseAddProvider extends ChangeNotifier {
  final TextEditingController courseController = TextEditingController();
  final TextEditingController staffController = TextEditingController();
  final TextEditingController subject1Controller = TextEditingController();
  final TextEditingController subject2Controller = TextEditingController();
  
  List<String> subjects = [];
  String selectedDay1 = '';
  String selectedDay2 = '';

  // Define day1 and day2 lists
  final List<String> day1 = ['MONDAY', 'WEDNESDAY', 'FRIDAY'];
  final List<String> day2 = ['TUESDAY', 'THURSDAY', 'FRIDAY'];

  void addSubject(String subject) {
    subjects.add(subject);
    notifyListeners();
  }

  void setSelectedDay1(String day) {
    selectedDay1 = day;
    notifyListeners();
  }

  void setSelectedDay2(String day) {
    selectedDay2 = day;
    notifyListeners();
  }

  void clear() {
    courseController.clear();
    staffController.clear();
    subject1Controller.clear();
    subject2Controller.clear();
    subjects.clear();
    notifyListeners();
  }

  void addData(CollectionReference data, BuildContext context) {
    final courseData = {
      'course': courseController.text.trim(),
      'staff': staffController.text.trim(),
      'sub1': subject1Controller.text.trim(),
      'sub2': subject2Controller.text.trim(),
      'day1': selectedDay1,
      'day2': selectedDay2,
    };

    data.add(courseData).then((_) {
      clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Course added successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Failed to add course: $error'),
        ),
      );
    });
  }
}
