import 'package:flutter/material.dart';

import '../services/index.dart';

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
