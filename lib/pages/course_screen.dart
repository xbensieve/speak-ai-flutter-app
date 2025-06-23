import 'package:english_app_with_ai/pages/premium_intro_screen.dart';
import 'package:english_app_with_ai/view_models/course_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/course_model.dart';
import 'course_detail_screen.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  String getLevelName(int levelId) {
    const levelMap = {
      1: 'A1',
      2: 'A2',
      3: 'B1',
      4: 'B2',
      5: 'C',
    };
    return levelMap[levelId] ?? 'Unknown';
  }

  void _showPremiumRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Premium Required',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: Text(
              'This course is only available for premium users. Please upgrade your account to access it.',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.roboto(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => PremiumIntroPage());
                },
                child: Text(
                  'Upgrade Now',
                  style: GoogleFonts.roboto(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CourseViewModel courseViewModel = Get.put(
      CourseViewModel(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseViewModel.fetchCourses();
      courseViewModel.checkPremium();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.04,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await courseViewModel.fetchCourses();
              await courseViewModel.checkPremium();
            },
            child: Obx(() {
              if (courseViewModel.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 20,
                  ),
                );
              }
              if (courseViewModel.error.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${courseViewModel.error.value}',
                          style: TextStyle(
                            color: Colors.red[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        OutlinedButton(
                          onPressed:
                              () =>
                                  courseViewModel
                                      .fetchCourses(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
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
                      'No courses available.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: courseViewModel.courses.length,
                itemBuilder: (context, index) {
                  final CourseModel course =
                      courseViewModel.courses[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      color: Colors.transparent,
                      // Card remains white for contrast
                      child: InkWell(
                        onTap: () {
                          if (course.isPremium &&
                              !courseViewModel
                                  .isPremium
                                  .value) {
                            _showPremiumRequiredDialog(
                              context,
                            );
                          } else {
                            Get.to(
                              () => CourseDetailPage(
                                courseId: course.id,
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.horizontal(
                                    left: Radius.circular(
                                      12,
                                    ),
                                  ),
                              child:
                                  course.imageUrl.isNotEmpty
                                      ? Image.network(
                                        course.imageUrl,
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => Container(
                                              width: 120,
                                              height: 100,
                                              color:
                                                  Colors
                                                      .grey[300],
                                              child: const Icon(
                                                Icons
                                                    .image_not_supported,
                                                size: 30,
                                                color:
                                                    Colors
                                                        .grey,
                                              ),
                                            ),
                                      )
                                      : Container(
                                        width: 120,
                                        height: 100,
                                        color:
                                            Colors
                                                .grey[300],
                                        child: const Icon(
                                          Icons
                                              .image_not_supported,
                                          size: 30,
                                          color:
                                              Colors.grey,
                                        ),
                                      ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      12,
                                    ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      course.courseName,
                                      style:
                                          GoogleFonts.poppins(
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                            fontSize: 16,
                                            color:
                                                Colors
                                                    .white,
                                          ),
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          0xFF6A89FF,
                                        ).withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(
                                              6,
                                            ),
                                      ),
                                      child: Text(
                                        'Level: ${getLevelName(course.levelId)}',
                                        style:
                                            GoogleFonts.poppins(
                                              fontSize: 12,
                                              color:
                                                  Colors
                                                      .cyan,
                                              fontWeight:
                                                  FontWeight
                                                      .w500,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          course.isPremium
                                              ? Icons.lock
                                              : Icons
                                                  .lock_open,
                                          size: 16,
                                          color:
                                              course.isPremium
                                                  ? Colors
                                                      .amber[700]
                                                  : Colors
                                                      .greenAccent,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          course.isPremium
                                              ? 'Premium'
                                              : 'Free',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                course.isPremium
                                                    ? Colors
                                                        .amber[700]
                                                    : Colors
                                                        .greenAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
