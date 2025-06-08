import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/course_view_model.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final CourseViewModel courseViewModel = Get.put(
    CourseViewModel(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseViewModel.fetchAllEnrolledCourseDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Courses',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (courseViewModel.isLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: Colors.white,
            ),
          );
        }

        if (courseViewModel.error.value.isNotEmpty) {
          return Center(
            child: Text(
              courseViewModel.error.value,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        final courses = courseViewModel.enrolledCourses;
        if (courses.isEmpty) {
          return const Center(
            child: Text(
              'No enrolled courses found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              color: Colors.blueGrey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading:
                    course.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: course.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  const CupertinoActivityIndicator(
                                    radius: 10,
                                    color: Colors.white70,
                                  ),
                          errorWidget:
                              (context, url, error) =>
                                  const Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                        )
                        : null,
                title: Text(
                  course.courseName,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  course.description,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {},
              ),
            );
          },
        );
      }),
    );
  }
}
