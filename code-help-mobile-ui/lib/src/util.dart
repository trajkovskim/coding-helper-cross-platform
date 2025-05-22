import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:flutter/material.dart';

const Map<String, Color> difficultyColors = {
  'easy': Colors.green,
  'medium': Colors.orange,
  'hard': Colors.red,
};

const Map<String, Color> submissionStatusColors = {
  'Not attempted': Colors.grey,
  'Attempted': Colors.orange,
  'Solved': Colors.green,
};

Color? getDifficultyColor(Difficulty difficulty) {
  return difficultyColors[difficulty.name.toLowerCase()];
}

Color? getSubmissionStatusColor(ProblemEntryBase problemEntry) {
  return submissionStatusColors[getSubmissionStatusText(problemEntry)];
}

String getSubmissionStatusText(ProblemEntryBase problemEntry) {

  final submissionStatus = problemEntry.lastAcceptedSubmission?.status;

  if (submissionStatus == null) {
    return 'Not attempted';
  }

  return submissionStatus == SubmissionStatus.ACCEPTED ? 'Solved' : 'Attempted';
}