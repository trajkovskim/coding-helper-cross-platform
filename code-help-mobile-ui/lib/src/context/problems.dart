import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:flutter/material.dart';

class ProblemsContext extends ChangeNotifier {
  List<ProblemEntry> _entries = [];

  List<ProblemEntry> get entries {
    return [..._entries];
  }

  void setProblems(List<ProblemEntry> entries) {
    _entries = entries;
    notifyListeners();
  }
}
