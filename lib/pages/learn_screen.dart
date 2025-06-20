import 'package:english_app_with_ai/pages/topic_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/enrolled_course_vm.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(EnrolledCourseViewModel());
    final double screenWidth =
        MediaQuery.of(context).size.width;
    final double screenHeight =
        MediaQuery.of(context).size.height;
    final double fontScale = screenWidth / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Enrolled Courses',
          style: GoogleFonts.roboto(
            fontSize: 25 * fontScale,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 24 * fontScale,
              color: Colors.black54,
            ),
            onPressed:
                () => viewModel.refreshEnrolledCourses(),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refreshEnrolledCourses,
        color: Colors.blueAccent,
        child: Obx(() {
          // Handle loading state
          if (viewModel.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 4 * fontScale,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
              ),
            );
          }

          if (viewModel.errorMessage.value.isNotEmpty) {
            return SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: screenHeight,
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 40 * fontScale,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16 * fontScale),
                      Text(
                        viewModel.errorMessage.value,
                        style: GoogleFonts.roboto(
                          fontSize: 16 * fontScale,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16 * fontScale),
                      ElevatedButton(
                        onPressed:
                            () =>
                                viewModel
                                    .refreshEnrolledCourses(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20 * fontScale,
                            vertical: 10 * fontScale,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  10 * fontScale,
                                ),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.roboto(
                            fontSize: 16 * fontScale,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (viewModel.enrolledCourses.isEmpty) {
            return SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: screenHeight,
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 40 * fontScale,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16 * fontScale),
                      Text(
                        'No enrolled courses found',
                        style: GoogleFonts.roboto(
                          fontSize: 18 * fontScale,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0 * fontScale),
            itemCount: viewModel.enrolledCourses.length,
            itemBuilder: (context, index) {
              final course =
                  viewModel.enrolledCourses[index];
              return InkWell(
                onTap: () {
                  Get.to(
                    () => TopicsScreen(
                      enrolledCourseId: course.id,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(
                  12 * fontScale,
                ),
                child: Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 8.0 * fontScale,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12 * fontScale,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      16.0 * fontScale,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 24 * fontScale,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 8 * fontScale),
                            Expanded(
                              child: Text(
                                'Course ID: ${course.courseId}',
                                style: GoogleFonts.roboto(
                                  fontSize: 18 * fontScale,
                                  fontWeight:
                                      FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12 * fontScale),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 20 * fontScale,
                              color:
                                  course.isCompleted
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                            SizedBox(width: 8 * fontScale),
                            Text(
                              'Completed: ${course.isCompleted ? "Yes" : "No"}',
                              style: GoogleFonts.roboto(
                                fontSize: 16 * fontScale,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8 * fontScale),
                        Text(
                          'Progress: ${course.progressPoints}%',
                          style: GoogleFonts.roboto(
                            fontSize: 16 * fontScale,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8 * fontScale),
                        LinearProgressIndicator(
                          value:
                              course.progressPoints / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              const AlwaysStoppedAnimation<
                                Color
                              >(Colors.blueAccent),
                          minHeight: 8 * fontScale,
                        ),
                        SizedBox(height: 12 * fontScale),
                        Text(
                          'Updated: ${course.updatedAt.toString().substring(0, 16)}',
                          style: GoogleFonts.roboto(
                            fontSize: 14 * fontScale,
                            color: Colors.black54,
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
    );
  }
}
