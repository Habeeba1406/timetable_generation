import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation/screens/cource_page/provider/cource_provider.dart';
import 'package:timetable_generation/screens/cource_page/view/course_page.dart';
import 'package:timetable_generation/screens/add_data/provider/add_data_provider.dart';
import 'package:timetable_generation/screens/updated_data_screen/provider/updated_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseAddProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => CourseStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.mulishTextTheme(),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.cyan.shade900,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.cyan.shade900,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.cyan.shade900),
        ),
        home: const CoursePage(),
      ),
    );
  }
}
