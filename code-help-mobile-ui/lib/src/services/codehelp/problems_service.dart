import 'package:coding_helper_api/coding_helper_api.dart';

import 'api.dart';

class ProblemsService {
  const ProblemsService();

  Future<List<ProblemEntry>> getProblemEntries() {
    return PROBLEMS_API
        .getProblemEntries()
        .then((response) => response.data!.problems.toList());
  }

  Future<List<ProblemByLikes>> getTop10ProblemEntries() {
    return PROBLEMS_API
        .getTop10Problems()
        .then((response) => response.data!.problems.toList());
  }

  Future<ProblemByLikes> getProblemEntry(String id) {
    return PROBLEMS_API
        .getProblemEntry(id: int.parse(id))
        .then((response) => response.data!);
  }

  Future<bool> isLiked(String id) {
    return PROBLEMS_API
        .isProblemEntryLiked(id: int.parse(id))
        .then((response) => response.data!);
  }

  Future<void> toggleLike(String id) {
    return PROBLEMS_API.toggleLikeProblemEntry(id: int.parse(id));
  }
}
