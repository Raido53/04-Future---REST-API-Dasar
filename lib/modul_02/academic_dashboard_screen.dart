import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({super.key});

  @override
  State<AcademicDashboardScreen> createState() =>
      _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState extends State<AcademicDashboardScreen> {
  final List<Course> _courses = Course.getSampleCourses();
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard Akademik TRPL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded),
              tooltip: _isDarkMode ? 'Mode Terang' : 'Mode Gelap',
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        // LayoutBuilder membaca ukuran layar untuk menentukan tata letak responsif
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Breakpoint 600dp: Tablet / Landscape menggunakan 2 kolom
            if (constraints.maxWidth >= 600) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom kiri: banner profil
                    const Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: HeaderBanner(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Kolom kanan: grid 2 kolom daftar mata kuliah
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          // Konten CourseCard memerlukan tinggi stabil; rasio
                          // lebar/tinggi 1.4 membuat kartu grid terlalu pendek.
                          mainAxisExtent: 230,
                        ),
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          return CourseCard(course: _courses[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            // Default (smartphone): tata letak 1 kolom vertikal
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const HeaderBanner(),
                const SizedBox(height: 16),
                Text(
                  'Mata Kuliah Semester 5 (${_courses.length} Terdaftar)',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._courses.map((course) => CourseCard(course: course)),
              ],
            );
          },
        ),
      ),
    );
  }
}
