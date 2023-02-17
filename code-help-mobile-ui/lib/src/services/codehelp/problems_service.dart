import 'package:coding_helper_api/coding_helper_api.dart';

import 'api.dart';

class ProblemsService {
  const ProblemsService();

  Future<List<ProblemEntry>> getProblemEntries() {
    return PROBLEMS_API
        .getProblemEntries()
        .then((value) => value.data!.problems.toList());
  }

  Future<ProblemByLikes> getProblemEntry(String id) {
    return PROBLEMS_API
        .getProblemEntry(id: int.parse(id))
        .then((value) => value.data!);
  }
}
