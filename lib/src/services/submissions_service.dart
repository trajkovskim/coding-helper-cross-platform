import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/services/api.dart';

class SubmissionsService {
  const SubmissionsService();

  Future<List<SubmissionEntry>> getSubmissionEntries(
    GetSubmissionsRequest request,
  ) {
    return SUBMISSIONS_API
        .getSubmissions(getSubmissionsRequest: request)
        .then((value) => value.data!.submissions.toList());
  }

  Future<String> submit(SubmissionReqBody request) {
    return SUBMISSIONS_API
        .createSubmissionsEntry(submissionReqBody: request)
        .then((value) => value.data!);
  }
}
