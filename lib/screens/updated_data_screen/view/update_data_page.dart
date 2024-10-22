import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation/screens/updated_data_screen/provider/updated_data_provider.dart';

class UpdateCourse extends StatelessWidget {
  final String coursename;
  final String staffname;
  final String sub1;
  final String sub2;
  final String day1;
  final String day2;
  final String id;

  const UpdateCourse({
    super.key,
    required this.coursename,
    required this.staffname,
    required this.sub1,
    required this.sub2,
    required this.day1,
    required this.day2,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseStateProvider()
        ..initializeData(
          coursename: coursename,
          staffname: staffname,
          sub1: sub1,
          sub2: sub2,
          day1: day1,
          day2: day2,
        ),
      child: _UpdateCourseContent(id: id),
    );
  }
}

class _UpdateCourseContent extends StatefulWidget {
  final String id;

  const _UpdateCourseContent({required this.id});

  @override
  State<_UpdateCourseContent> createState() => _UpdateCourseContentState();
}

class _UpdateCourseContentState extends State<_UpdateCourseContent> {
  late TextEditingController courseController;
  late TextEditingController staffController;
  late TextEditingController subject1Controller;
  late TextEditingController subject2Controller;

  @override
  void initState() {
    super.initState();
    courseController = TextEditingController();
    staffController = TextEditingController();
    subject1Controller = TextEditingController();
    subject2Controller = TextEditingController();
  }

  @override
  void dispose() {
    courseController.dispose();
    staffController.dispose();
    subject1Controller.dispose();
    subject2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseState = Provider.of<CourseStateProvider>(context);

    // Update controllers with current state
    courseController.text = courseState.courseName;
    staffController.text = courseState.staffName;
    subject1Controller.text = courseState.subject1;
    subject2Controller.text = courseState.subject2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        title: const Text(
          'UPDATE COURSE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 150,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: courseController,
                onChanged: (value) => courseState.setCourseName(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan.shade900),
                  ),
                  hintText: 'Enter Course',
                  hintStyle: TextStyle(color: Colors.cyan.shade900),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'UPDATE STAFF AND SUBJECTS IN RELATED COURSE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _updateStaffSubDialog(context, courseState),
                    child: Icon(
                      Icons.edit,
                      color: Colors.cyan.shade900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: courseState.subjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          courseState.subjects[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.cyan.shade900,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField<String>(
                value: courseState.selectedDay1.isNotEmpty
                    ? courseState.selectedDay1
                    : null,
                decoration: InputDecoration(
                  labelText: "Select day 1",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan.shade900,
                  ),
                  border: const OutlineInputBorder(),
                ),
                items: courseState.day1Options
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: courseState.setDay1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField<String>(
                value: courseState.selectedDay2.isNotEmpty
                    ? courseState.selectedDay2
                    : null,
                decoration: InputDecoration(
                  labelText: "Select day 2",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan.shade900,
                  ),
                  border: const OutlineInputBorder(),
                ),
                items: courseState.day2Options
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: courseState.setDay2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.cyan.shade900),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                onPressed: () =>
                    courseState.updateCourseData(widget.id, context),
                child: const Text(
                  'UPDATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStaffSubDialog(
      BuildContext context, CourseStateProvider courseState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add STAFF AND RELATED SUBJECTS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.cyan.shade900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: staffController,
                onChanged: (value) => courseState.setStaffName(value),
                decoration: const InputDecoration(
                  hintText: 'Enter Staff',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: subject1Controller,
                decoration: const InputDecoration(
                  hintText: 'Enter Subject 1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: subject2Controller,
                decoration: const InputDecoration(
                  hintText: 'Enter Subject 2',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.cyan.shade900,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (subject1Controller.text.isNotEmpty &&
                    subject2Controller.text.isNotEmpty) {
                  courseState.updateSubjects(
                    subject1Controller.text,
                    subject2Controller.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Update',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.cyan.shade900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
