import 'package:coding_helper_api/coding_helper_api.dart';
import 'api.dart';

class SubmissionsService {
  const SubmissionsService();

  Future<List<SubmissionEntry>> getSubmissionEntries(int problemId) {
    return SUBMISSIONS_API
        .getSubmissions(problemId: problemId)
        .then((value) => value.data!.submissions.toList());
  }

  Future<CreatedSubmissionResponse> submit(int problemId, SubmissionBaseEntry request) {
    return SUBMISSIONS_API
        .createSubmissionsEntry(problemId: problemId, submissionBaseEntry: request)
        .then((value) => value.data!);
  }
}
