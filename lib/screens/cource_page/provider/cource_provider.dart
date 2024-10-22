import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetable_generation/model/cource_model.dart';

class CourseProvider with ChangeNotifier {
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('data');

  List<Course> _courses = [];
  bool _isLoading = true;
  DateTime? _lastRefreshed;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  DateTime? get lastRefreshed => _lastRefreshed;

  CourseProvider() {
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _dataCollection.get();
      _courses = snapshot.docs.map((doc) => Course.fromDocument(doc)).toList();

      // Sort courses alphabetically
      _courses.sort((a, b) => a.course.compareTo(b.course));

      _lastRefreshed = DateTime.now();
    } catch (error) {
      debugPrint('Error fetching courses: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCourses(BuildContext context) async {
    try {
      await fetchCourses();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Courses refreshed successfully'),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh courses: $error'),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await _dataCollection.doc(id).delete();
      await fetchCourses();
    } catch (error) {
      debugPrint('Error deleting course: $error');
    }
  }
}
