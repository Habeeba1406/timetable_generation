import 'package:flutter/material.dart';

class Time extends StatefulWidget {
  final String subject1;
  final String subject2;
  final TimeOfDay? initialTimeSubject1;
  final TimeOfDay? initialTimeSubject2;

  const Time({
    super.key,
    required this.subject1,
    required this.subject2,
    this.initialTimeSubject1,
    this.initialTimeSubject2,
  });

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  TimeOfDay? timeSubject1;
  TimeOfDay? timeSubject2;

  @override
  void initState() {
    super.initState();
    timeSubject1 = widget.initialTimeSubject1;
    timeSubject2 = widget.initialTimeSubject2;
  }

  Future<void> _selectTime(BuildContext context, String subject) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (subject == widget.subject1) {
          timeSubject1 = picked;
        } else if (subject == widget.subject2) {
          timeSubject2 = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const Text(
          'Set Shedule Time',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.subject1),
              subtitle: Text(
                timeSubject1 != null
                    ? 'Scheduled at: ${timeSubject1!.format(context)}'
                    : 'No time selected',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _selectTime(context, widget.subject1),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(widget.subject2),
              subtitle: Text(
                timeSubject2 != null
                    ? 'Scheduled at: ${timeSubject2!.format(context)}'
                    : 'No time selected',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _selectTime(context, widget.subject2),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.cyan.shade900)),
              onPressed: () {
                Navigator.pop(context, {
                  'subject1': timeSubject1,
                  'subject2': timeSubject2,
                });
              },
              child: const Text(
                'Save Schedule',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
