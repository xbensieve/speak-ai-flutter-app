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

  const QuizScreen({
    super.key,
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
        elevation: 0,
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
        child: Obx(() => _buildBody(context, viewModel)),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    QuizViewModel viewModel,
  ) {
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
      return _QuizCompleted(viewModel: viewModel);
    }

    final question =
        exercise.questions[viewModel
            .currentQuestionIndex
            .value];
    return _QuizContent(
      viewModel: viewModel,
      question: question,
    );
  }
}

class _QuizCompleted extends StatelessWidget {
  final QuizViewModel viewModel;

  const _QuizCompleted({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(duration: 500.ms).scale(),
          const SizedBox(height: 16),
          Text(
            'Score: ${viewModel.score.value}/${viewModel.exercise.questions.length}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Back to Exercises',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizContent extends StatelessWidget {
  final QuizViewModel viewModel;
  final Question question;

  const _QuizContent({
    required this.viewModel,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProgressBar(viewModel: viewModel),
                const SizedBox(height: 16),
                _QuestionHeader(viewModel: viewModel),
                const SizedBox(height: 16),
                Text(
                  question.content,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 16),
                _AnswerList(
                  viewModel: viewModel,
                  question: question,
                ),
                const Spacer(),
                _NextButton(viewModel: viewModel),
              ],
            ),
          ),
          _FeedbackPopup(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final QuizViewModel viewModel;

  const _ProgressBar({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value:
          (viewModel.currentQuestionIndex.value + 1) /
          viewModel.exercise.questions.length,
      backgroundColor: Colors.white24,
      valueColor: const AlwaysStoppedAnimation<Color>(
        Colors.blueAccent,
      ),
      minHeight: 8,
      borderRadius: BorderRadius.circular(4),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _QuestionHeader extends StatelessWidget {
  final QuizViewModel viewModel;

  const _QuestionHeader({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Question ${viewModel.currentQuestionIndex.value + 1}/${viewModel.exercise.questions.length}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _AnswerList extends StatelessWidget {
  final QuizViewModel viewModel;
  final Question question;

  const _AnswerList({
    required this.viewModel,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: question.answers.length,
        itemBuilder: (context, index) {
          final answer = question.answers[index];
          return _AnswerTile(
            viewModel: viewModel,
            answer: answer,
            isSelected:
                viewModel.selectedAnswer.value == answer.id,
          ).animate().fadeIn(
            delay: (100 * index).ms,
            duration: 300.ms,
          );
        },
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  final QuizViewModel viewModel;
  final Answer answer;
  final bool isSelected;

  const _AnswerTile({
    required this.viewModel,
    required this.answer,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          isSelected
              ? Colors.blueAccent.withOpacity(0.2)
              : Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          answer.content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        leading: Obx(
          () => Radio<String>(
            value: answer.id,
            groupValue: viewModel.selectedAnswer.value,
            onChanged:
                (value) => viewModel.selectAnswer(value!),
            activeColor: Colors.blueAccent,
          ),
        ),
        onTap: () => viewModel.selectAnswer(answer.id),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final QuizViewModel viewModel;

  const _NextButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed:
            viewModel.isAnswerCorrect.value &&
                    viewModel
                        .selectedAnswer
                        .value
                        .isNotEmpty
                ? viewModel.nextQuestion
                : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blueAccent,
          disabledBackgroundColor: Colors.grey.shade600,
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class _FeedbackPopup extends StatelessWidget {
  final QuizViewModel viewModel;

  const _FeedbackPopup({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!viewModel.showFeedback.value) {
        return const SizedBox.shrink();
      }

      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                    imageUrl:
                        viewModel.isAnswerCorrect.value
                            ? 'https://media.tenor.com/JsoERRQcZqYAAAAi/thumbs-up-joypixels.gif'
                            : 'https://media.tenor.com/HKnvtwrIBlYAAAAi/x-no.gif',
                    height: 100,
                    placeholder:
                        (context, url) =>
                            const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(duration: 500.ms),
              const SizedBox(height: 16),
              Text(
                viewModel.isAnswerCorrect.value
                    ? 'Correct!'
                    : 'Wrong, try again',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      viewModel.isAnswerCorrect.value
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
