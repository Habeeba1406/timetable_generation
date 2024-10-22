import 'package:flutter/material.dart';
import 'package:timetable_generation/screens/timetable/time_table.dart';
import '../timetable/time.dart';

class CourseDetailsPage extends StatefulWidget {
  final String course;
  final String staff;
  final String sub1;
  final String sub2;
  final String day1;
  final String day2;

  const CourseDetailsPage({
    super.key,
    required this.course,
    required this.staff,
    required this.sub1,
    required this.sub2,
    required this.day1,
    required this.day2,
  });

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  TimeOfDay? timeSubject1;
  TimeOfDay? timeSubject2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        title: Text(
          widget.course,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AutoTimetableScreen(),
                ),
              );
            },
            icon: const Icon(Icons.table_chart_outlined, size: 28),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher Info
            _buildInfoCard(
              title: 'Teacher',
              content: widget.staff,
              icon: Icons.person,
            ),
            const SizedBox(height: 20),

            // Subject 1 Info
            _buildSubjectCard(
              subjectTitle: widget.sub1,
              day: widget.day1,
              time: timeSubject1 != null
                  ? timeSubject1!.format(context)
                  : 'No time set for Subject 1',
            ),
            const SizedBox(height: 20),

            // Subject 2 Info
            _buildSubjectCard(
              subjectTitle: widget.sub2,
              day: widget.day2,
              time: timeSubject2 != null
                  ? timeSubject2!.format(context)
                  : 'No time set for Subject 2',
            ),
            const SizedBox(height: 40),

            // Time button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Navigate to Time and wait for the result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Time(
                        subject1: widget.sub1,
                        subject2: widget.sub2,
                        initialTimeSubject1: timeSubject1,
                        initialTimeSubject2: timeSubject2,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      timeSubject1 = result['sub1'];
                      timeSubject2 = result['sub2'];
                    });
                  }
                },
                icon: Icon(
                  Icons.schedule_outlined,
                  color: Colors.cyan.shade900,
                ),
                label: Text(
                  'Set Time',
                  style: TextStyle(color: Colors.cyan.shade900),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: const Color.fromARGB(255, 240, 247, 247),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title,
      required String content,
      required IconData icon}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.cyan.shade900, size: 36),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.cyan.shade900,
          ),
        ),
        subtitle: Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSubjectCard({
    required String subjectTitle,
    required String day,
    required String time,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject: $subjectTitle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.cyan.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scheduled day: $day',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Scheduled time: $time',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
