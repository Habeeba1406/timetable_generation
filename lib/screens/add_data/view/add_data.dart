import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation/screens/add_data/provider/add_data_provider.dart';
import 'package:timetable_generation/screens/cource_page/view/course_page.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final CollectionReference data =
      FirebaseFirestore.instance.collection('data');
  final courseController = TextEditingController();
  final staffController = TextEditingController();
  final subject1Controller = TextEditingController();
  final subject2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> subjects = [];
  bool isLoading = false;

  @override
  void dispose() {
    courseController.dispose();
    staffController.dispose();
    subject1Controller.dispose();
    subject2Controller.dispose();
    super.dispose();
  }

  Future<void> addData(CourseAddProvider provider) async {
    if (isLoading) return; // Prevent double submission

    if (!_formKey.currentState!.validate()) return;
    if (subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one subject'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (provider.selectedDay1.isEmpty || provider.selectedDay2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both days'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final courseData = {
        'course': courseController.text.trim(),
        'staff': staffController.text.trim(),
        'sub1': subject1Controller.text.trim(),
        'sub2': subject2Controller.text.trim(),
        'day1': provider.selectedDay1,
        'day2': provider.selectedDay2,
      };

      await data.add(courseData);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to CoursePage
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const CoursePage()),
        (route) => false, // This will remove all previous routes
      );
    } catch (error) {
      debugPrint('Error adding course: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseAddProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADD DATA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: courseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan.shade900),
                    ),
                    hintText: 'Enter Course',
                    hintStyle: TextStyle(color: Colors.cyan.shade900),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter course name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ADD STAFF AND SUBJECTS\nIN RELATED COURSE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade900,
                      ),
                    ),
                    IconButton(
                      onPressed: _addStaffSubDialog,
                      icon: Icon(
                        Icons.add,
                        color: Colors.cyan.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            subjects[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.cyan.shade900,
                            ),
                          ),
                          subtitle: Text(staffController.text),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                subjects.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select day 1",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade900,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  value: provider.selectedDay1.isEmpty
                      ? null
                      : provider.selectedDay1,
                  items: provider.day1
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    provider.setSelectedDay1(value.toString());
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select day 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select day 2",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade900,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  value: provider.selectedDay2.isEmpty
                      ? null
                      : provider.selectedDay2,
                  items: provider.day2
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    provider.setSelectedDay2(value.toString());
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select day 2';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    if (!isLoading) {
                      await addData(provider);
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addStaffSubDialog() {
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
              TextFormField(
                controller: staffController,
                decoration: const InputDecoration(
                  hintText: 'Enter Staff',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter staff name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: subject1Controller,
                decoration: const InputDecoration(
                  hintText: 'Enter Subject 1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter subject 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: subject2Controller,
                decoration: const InputDecoration(
                  hintText: 'Enter Subject 2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter subject 2';
                  }
                  return null;
                },
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
                if (subject1Controller.text.trim().isNotEmpty &&
                    subject2Controller.text.trim().isNotEmpty) {
                  setState(() {
                    subjects.add(subject1Controller.text.trim());
                    subjects.add(subject2Controller.text.trim());
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
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
