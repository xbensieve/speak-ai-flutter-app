import 'package:english_app_with_ai/view_models/course_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/course_model.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  String getLevelName(int levelId) {
    const levelMap = {1: 'A1', 2: 'A2', 3: 'B1', 4: 'B2', 5: 'C'};
    return levelMap[levelId] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final CourseViewModel courseViewModel = Get.put(CourseViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseViewModel.fetchCourses();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Courses",
          style: GoogleFonts.roboto(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => courseViewModel.fetchCourses(),
          child: Obx(() {
            if (courseViewModel.isLoading.value) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 20),
              );
            }
            if (courseViewModel.error.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${courseViewModel.error.value}',
                        style: TextStyle(color: Colors.red[700], fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => courseViewModel.fetchCourses(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (courseViewModel.courses.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No courses found.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.66, // Slightly increased for extra space
              ),
              itemCount: courseViewModel.courses.length,
              itemBuilder: (context, index) {
                final CourseModel course = courseViewModel.courses[index];
                return Card(
                  color: Colors.transparent,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white, width: 1.2),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.snackbar(
                        'Course Selected',
                        '${course.courseName} (Level: ${getLevelName(course.levelId)})',
                        backgroundColor: Colors.blue[700],
                        colorText: Colors.white,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image and Premium Icon
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child:
                                  course.imageUrl.isNotEmpty
                                      ? Image.network(
                                        course.imageUrl,
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      )
                                      : Container(
                                        width: double.infinity,
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                            // Premium Icon
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  course.isPremium
                                      ? Icons.lock
                                      : Icons.lock_open,
                                  color:
                                      course.isPremium
                                          ? Colors.amber[700]
                                          : Colors.green[700],
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Course Name and Level, wrapped in Expanded
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.courseName,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Level: ${getLevelName(course.levelId)}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                                // Add a small spacer to absorb any leftover space
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
