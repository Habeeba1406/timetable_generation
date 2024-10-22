import 'package:flutter/material.dart';

class Course {
  final String name;
  final String teacher;
  final String subject1;
  final String subject2;
  final String day1;
  final String day2;
  TimeOfDay? timeSubject1;
  TimeOfDay? timeSubject2;

  Course({
    required this.name,
    required this.teacher,
    required this.subject1,
    required this.subject2,
    required this.day1,
    required this.day2,
    this.timeSubject1,
    this.timeSubject2,
  });
}

class AutoTimetableScreen extends StatefulWidget {
  const AutoTimetableScreen({super.key});

  @override
  State<AutoTimetableScreen> createState() => _AutoTimetableScreenState();
}

class _AutoTimetableScreenState extends State<AutoTimetableScreen> {
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final List<String> timeSlots = [
    '9:00-10:00',
    '10:00-11:00',
    '11:15-12:15',
    '12:15-1:15',
    '2:00-3:00',
    '3:00-4:00'
  ];

  // List to store all courses
  List<Course> courses = [];

  // Map to store the timetable
  Map<String, List<String>> timetable = {};

  @override
  void initState() {
    super.initState();
    // Initialize empty timetable
    for (var day in days) {
      timetable[day] = List.filled(6, '');
    }
  }

  void _addCourse() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String teacher = '';
        String subject1 = '';
        String subject2 = '';
        String day1 = days[0];
        String day2 = days[2];

        return AlertDialog(
          title: const Text('Add New Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Teacher Name'),
                  onChanged: (value) => teacher = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Subject 1'),
                  onChanged: (value) => subject1 = value,
                ),
                DropdownButton<String>(
                  value: day1,
                  items: days.map((day) {
                    return DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      day1 = value!;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Subject 2'),
                  onChanged: (value) => subject2 = value,
                ),
                DropdownButton<String>(
                  value: day2,
                  items: days.map((day) {
                    return DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      day2 = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  courses.add(Course(
                    name: name,
                    teacher: teacher,
                    subject1: subject1,
                    subject2: subject2,
                    day1: day1,
                    day2: day2,
                  ));
                });
                Navigator.pop(context);
                _generateTimetable();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _generateTimetable() {
    // Clear existing timetable
    for (var day in days) {
      timetable[day] = List.filled(6, '');
    }

    // Generate timetable for each course
    for (var course in courses) {
      // Find empty slot for subject 1
      bool scheduled1 = false;
      for (int i = 0; i < timeSlots.length && !scheduled1; i++) {
        if (timetable[course.day1]![i].isEmpty) {
          timetable[course.day1]![i] =
              '${course.subject1}\n(${course.teacher})\n${course.name}';
          scheduled1 = true;
        }
      }

      // Find empty slot for subject 2
      bool scheduled2 = false;
      for (int i = 0; i < timeSlots.length && !scheduled2; i++) {
        if (timetable[course.day2]![i].isEmpty) {
          timetable[course.day2]![i] =
              '${course.subject2}\n(${course.teacher})\n${course.name}';
          scheduled2 = true;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TIMETABLE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.cyan.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Time slots column
              Row(
                children: [
                  // Empty cell for top-left corner
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade900,
                        ),
                      ),
                    ),
                  ),
                  // Days row
                  ...days.map((day) => Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.cyan.shade900,
                            border: Border.all(color: Colors.cyan.shade900),
                          ),
                          child: Center(
                            child: Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              // Timetable grid
              ...List.generate(timeSlots.length, (timeIndex) {
                return Row(
                  children: [
                    // Time slot
                    SizedBox(
                      width: 100,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan.shade900),
                        ),
                        child: Center(
                          child: Text(
                            timeSlots[timeIndex],
                            style: TextStyle(
                              color: Colors.cyan.shade900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Day cells
                    ...days.map((day) => Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.cyan.shade900),
                            ),
                            child: Center(
                              child: Text(
                                timetable[day]![timeIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.cyan.shade900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateTimetable,
        backgroundColor: Colors.cyan.shade900,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
