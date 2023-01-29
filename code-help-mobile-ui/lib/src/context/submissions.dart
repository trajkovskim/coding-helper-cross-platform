import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:flutter/cupertino.dart';

class SubmissionsContext extends ChangeNotifier {
  List<SubmissionEntry> _entries = [];

  List<SubmissionEntry> get entries {
    return [..._entries];
  }

  void setSubmissions(List<SubmissionEntry> entries) {
    _entries = entries;
    notifyListeners();
  }
}
