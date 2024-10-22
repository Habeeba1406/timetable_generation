// course_state_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseStateProvider extends ChangeNotifier {
  final CollectionReference data =
      FirebaseFirestore.instance.collection('data');

  String _courseName = '';
  String _staffName = '';
  String _subject1 = '';
  String _subject2 = '';
  String _selectedDay1 = '';
  String _selectedDay2 = '';
  List<String> _subjects = [];

  // Getters
  String get courseName => _courseName;
  String get staffName => _staffName;
  String get subject1 => _subject1;
  String get subject2 => _subject2;
  String get selectedDay1 => _selectedDay1;
  String get selectedDay2 => _selectedDay2;
  List<String> get subjects => List.unmodifiable(_subjects);

  final List<String> day1Options = ['MONDAY', 'WEDNESDAY', 'FRIDAY'];
  final List<String> day2Options = ['TUESDAY', 'THURSDAY', 'FRIDAY'];

  void initializeData({
    required String coursename,
    required String staffname,
    required String sub1,
    required String sub2,
    required String day1,
    required String day2,
  }) {
    _courseName = coursename;
    _staffName = staffname;
    _subject1 = sub1;
    _subject2 = sub2;
    _selectedDay1 = day1;
    _selectedDay2 = day2;
    _subjects = [sub1, sub2];
    notifyListeners();
  }

  void updateSubjects(String sub1, String sub2) {
    _subject1 = sub1;
    _subject2 = sub2;
    _subjects = [sub1, sub2];
    notifyListeners();
  }

  void setDay1(String? day) {
    if (day != null) {
      _selectedDay1 = day;
      notifyListeners();
    }
  }

  void setDay2(String? day) {
    if (day != null) {
      _selectedDay2 = day;
      notifyListeners();
    }
  }

  void setCourseName(String name) {
    _courseName = name;
    notifyListeners();
  }

  void setStaffName(String name) {
    _staffName = name;
    notifyListeners();
  }

  Future<void> updateCourseData(String docId, BuildContext context) async {
    if (_courseName.isEmpty ||
        _staffName.isEmpty ||
        _subject1.isEmpty ||
        _subject2.isEmpty ||
        _selectedDay1.isEmpty ||
        _selectedDay2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final updatedData = {
        'course': _courseName,
        'staff': _staffName,
        'sub1': _subject1,
        'sub2': _subject2,
        'day1': _selectedDay1,
        'day2': _selectedDay2,
      };

      await data.doc(docId).update(updatedData);

      // Clear the data
      _courseName = '';
      _staffName = '';
      _subject1 = '';
      _subject2 = '';
      _selectedDay1 = '';
      _selectedDay2 = '';
      _subjects.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course Updated Successfully!')),
      );
      notifyListeners();

      // Navigate back after successful update
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $error')),
      );
    }
  }
}
