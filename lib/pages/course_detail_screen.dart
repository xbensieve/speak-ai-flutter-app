import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_models/course_view_model.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

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

  @override
  Widget build(BuildContext context) {
    final CourseViewModel viewModel = Get.put(
      CourseViewModel(),
    );
    print(courseId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchCourseById(courseId);
      viewModel.checkEnrolledCourse(courseId);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
          ),
        ),
        child: Obx(() {
          if (viewModel.isLoading.value) {
            return Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 20,
              ),
            );
          }

          if (viewModel.error.value.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${viewModel.error.value}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          final course = viewModel.selectedCourse.value;
          if (course == null) {
            return const Center(
              child: Text(
                'Course not found',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    course.courseName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 20,
                    ),
                  ),
                  background: CachedNetworkImage(
                    imageUrl: course.imgUrl,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                            radius: 20,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white.withOpacity(
                          0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            16.0,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Course Overview',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                course.description,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                textAlign:
                                    TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.white.withOpacity(
                          0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            16.0,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Course Details',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                'Max Points',
                                course.maxPoint.toString(),
                              ),
                              _buildDetailRow(
                                'Level',
                                getLevelName(
                                  course.levelId,
                                ),
                              ),
                              _buildDetailRow(
                                'Premium',
                                course.isPremium
                                    ? 'Yes'
                                    : 'No',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildActionButton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final CourseViewModel viewModel = Get.put(
      CourseViewModel(),
    );
    return Obx(() {
      final isEnrolled =
          viewModel.enrollmentStatus.value != null;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor:
                isEnrolled ? Colors.green : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            if (isEnrolled) {
              Get.snackbar(
                'Action',
                'Continuing to learn...',
                backgroundColor: Colors.green.withOpacity(
                  0.8,
                ),
              );
            } else {
              final success = await viewModel.enrollCourse(
                courseId,
              );
              if (success) {
                Get.snackbar(
                  'Success',
                  'Course enrolled successfully!',
                  backgroundColor: Colors.green.withOpacity(
                    0.8,
                  ),
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Enrollment failed. Check logs for details.',
                  backgroundColor: Colors.red.withOpacity(
                    0.8,
                  ),
                );
              }
            }
          },
          child: Text(
            isEnrolled
                ? 'Continue to Learn'
                : 'Enroll Course',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }
}
