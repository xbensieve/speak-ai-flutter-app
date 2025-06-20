import 'package:english_app_with_ai/pages/quiz_screen.dart';
import 'package:english_app_with_ai/services/abstract/i_course_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_models/course_content_vm.dart';

class CourseContentScreen extends StatelessWidget {
  final String courseId;
  final String topicId;

  CourseContentScreen({
    required this.courseId,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(
      CourseContentViewModel(
        courseService: Get.find<ICourseService>(),
        courseId: courseId,
        topicId: topicId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Exercises'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.errorMessage.value.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${viewModel.errorMessage.value}',
              ),
            );
          }

          if (viewModel.exercises.isEmpty) {
            return const Center(
              child: Text(
                'No exercises found for this topic.',
              ),
            );
          }

          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: viewModel.exercises.length,
              itemBuilder: (context, index) {
                final exercise = viewModel.exercises[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: ListTile(
                    title: Text(
                      exercise.content,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Max Points: ${exercise.maxPoint}',
                    ),
                    onTap: () {
                      Get.to(
                        () => QuizScreen(
                          exercise: exercise,
                          courseId: courseId,
                          topicId: topicId,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
