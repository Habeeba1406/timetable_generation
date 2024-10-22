import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation/model/cource_model.dart';
import 'package:timetable_generation/screens/cource_page/provider/cource_provider.dart';
import 'package:timetable_generation/screens/add_data/view/add_data.dart';
import 'package:timetable_generation/screens/datadetails/details_page.dart';
import 'package:timetable_generation/screens/updated_data_screen/view/update_data_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    super.initState();
    // Delay the refresh call slightly to ensure proper widget initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().refreshCourses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.cyan.shade900,
        title: const Text(
          'COURSES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan.shade900,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourse()),
          );
          // Refresh the courses list when returning from AddCourse
          if (mounted) {
            context.read<CourseProvider>().refreshCourses(context);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: const CourseGrid(),
    );
  }
}

class CourseGrid extends StatelessWidget {
  const CourseGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan.shade900,
            ),
          );
        }

        if (courseProvider.courses.isEmpty) {
          return Center(
            child: Text(
              'No courses available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.cyan.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: Colors.cyan.shade900,
          onRefresh: () async {
            await courseProvider.refreshCourses(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: courseProvider.courses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: courseProvider.courses[index]);
              },
            ),
          ),
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    course.course,
                    style: TextStyle(
                      color: Colors.cyan.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    onTap: () => _navigateToUpdate(context),
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    onTap: () => _deleteCourse(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Colors.grey.shade600,
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToDetails(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsPage(
          course: course.course,
          staff: course.staff,
          sub1: course.sub1,
          sub2: course.sub2,
          day1: course.day1,
          day2: course.day2,
        ),
      ),
    );
    if (context.mounted) {
      context.read<CourseProvider>().refreshCourses(context);
    }
  }

  Future<void> _navigateToUpdate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCourse(
          coursename: course.course,
          staffname: course.staff,
          sub1: course.sub1,
          sub2: course.sub2,
          day1: course.day1,
          day2: course.day2,
          id: course.id,
        ),
      ),
    );
    if (context.mounted) {
      context.read<CourseProvider>().refreshCourses(context);
    }
  }

  void _deleteCourse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Course',
          style: TextStyle(
            color: Colors.cyan.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${course.course}?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.cyan.shade900,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CourseProvider>(context, listen: false)
                  .deleteCourse(course.id);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
