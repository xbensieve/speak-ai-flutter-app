import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../view_models/quiz_vm.dart';

class QuizScreen extends StatelessWidget {
  final Exercise exercise;
  final String courseId;
  final String topicId;

  QuizScreen({
    required this.exercise,
    required this.courseId,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(
      QuizViewModel(
        exercise: exercise,
        courseId: courseId,
        topicId: topicId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${exercise.content} Quiz'),
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

          if (viewModel.currentQuestionIndex.value >=
              exercise.questions.length) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Quiz Completed!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Score: ${viewModel.score.value}/${exercise.questions.length}',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Back to Exercises'),
                  ),
                ],
              ),
            );
          }

          final question =
              exercise.questions[viewModel
                  .currentQuestionIndex
                  .value];
          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value:
                            (viewModel
                                    .currentQuestionIndex
                                    .value +
                                1) /
                            exercise.questions.length,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<
                              Color
                            >(Colors.blueAccent),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Question ${viewModel.currentQuestionIndex.value + 1}/${exercise.questions.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question.content,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...question.answers.map((answer) {
                        return ListTile(
                          title: Text(answer.content),
                          leading: Obx(
                            () => Radio<String>(
                              value: answer.id,
                              groupValue:
                                  viewModel
                                      .selectedAnswer
                                      .value,
                              onChanged: (value) {
                                viewModel.selectAnswer(
                                  value!,
                                );
                              },
                            ),
                          ),
                          onTap: () {
                            viewModel.selectAnswer(
                              answer.id,
                            );
                          },
                        );
                      }).toList(),
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            viewModel
                                        .isAnswerCorrect
                                        .value &&
                                    viewModel
                                        .selectedAnswer
                                        .value
                                        .isNotEmpty
                                ? viewModel.nextQuestion
                                : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
                // Feedback Popup
                Obx(() {
                  if (viewModel.showFeedback.value) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(
                                  imageUrl:
                                      viewModel
                                              .isAnswerCorrect
                                              .value
                                          ? 'https://giphy.com/embed/3o7TKTDn976rzVgky4' // Replace with correct GIF URL
                                          : 'https://giphy.com/embed/3o7TKQdJ3t8aK6eLmQ',
                                  // Replace with wrong GIF URL
                                  placeholder:
                                      (context, url) =>
                                          const CircularProgressIndicator(),
                                  errorWidget:
                                      (
                                        context,
                                        url,
                                        error,
                                      ) => const Icon(
                                        Icons.error,
                                      ),
                                )
                                .animate()
                                .fadeIn(duration: 500.ms)
                                .scale(duration: 500.ms),
                            const SizedBox(height: 16),
                            Text(
                              viewModel
                                      .isAnswerCorrect
                                      .value
                                  ? 'Correct!'
                                  : 'Wrong, try again',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    viewModel
                                            .isAnswerCorrect
                                            .value
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
