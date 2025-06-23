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
          'My Courses',
          style: GoogleFonts.roboto(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh:
              () => viewModel.refreshEnrolledCourses(),
          color: Colors.white,
          backgroundColor: Colors.white10,
          child: Obx(() {
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
              return Center(
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
              );
            }

            return ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(),
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
                      side: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1 * fontScale,
                      ),
                    ),
                    color: Colors.transparent,
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
                                Icons.bookmark_add_rounded,
                                size: 24 * fontScale,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 8 * fontScale,
                              ),
                              Expanded(
                                child: Text(
                                  'Course ID: #${course.courseId}',
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize:
                                        15 * fontScale,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.white,
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
                              SizedBox(
                                width: 8 * fontScale,
                              ),
                              Text(
                                'Completed: ${course.isCompleted ? "Yes" : "No"}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16 * fontScale,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * fontScale),
                          Text(
                            'Progress: ${course.progressPoints}',
                            style: GoogleFonts.roboto(
                              fontSize: 16 * fontScale,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8 * fontScale),
                          LinearProgressIndicator(
                            value: course.progressPoints,
                            backgroundColor:
                                Colors.grey[200],
                            valueColor:
                                const AlwaysStoppedAnimation<
                                  Color
                                >(Colors.blueAccent),
                            minHeight: 8 * fontScale,
                            borderRadius:
                                BorderRadius.circular(4),
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
    );
  }
}
