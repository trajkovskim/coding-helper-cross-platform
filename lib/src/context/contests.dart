import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:flutter/cupertino.dart';

class ContestsContext extends ChangeNotifier {
  List<ContestEntry> _entries = [];

  List<ContestEntry> get entries {
    return [..._entries];
  }

  void setContests(List<ContestEntry> entries) {
    _entries = entries;
    notifyListeners();
  }
}
