import 'package:coding_helper_api/coding_helper_api.dart';

import 'api.dart';

class ContestsService {
  const ContestsService();

  Future<List<ContestEntry>> getContestEntries() {
    return CONTESTS_API
        .getContestEntries()
        .then((value) => value.data!.contests.toList());
  }

  Future<ContestEntry> getContestEntry(String id) {
    return CONTESTS_API
        .getContestEntry(id: int.parse(id), language: '')
        .then((value) => value.data!);
  }

  Future<ContestProblem> getContestProblemEntry(
      String contestId, String problemId) {
    return CONTESTS_API
        .getContestProblem(
            contestId: int.parse(contestId), problemId: int.parse(problemId), language: '')
        .then((value) => value.data!);
  }
}
