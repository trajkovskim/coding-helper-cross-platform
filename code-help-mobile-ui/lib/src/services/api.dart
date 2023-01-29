import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: const String.fromEnvironment('CODING_HELPER_API_URL'),
  ),
);

final _API = CodingHelperApi(dio: dio);

final PROBLEMS_API = _API.getProblemsApi();
final CONTEST_API = _API.getContestApi();
final CONTESTS_API = _API.getContestsApi();
final CODE_RUNNER_API = _API.getCodeRunnerApi();
final AUTH_API = _API.getAuthApi();
final SUBMISSIONS_API = _API.getSubmissionsApi();
final SUBMIT_API = _API.getSubmitApi();
