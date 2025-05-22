import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:dio/dio.dart';

const codeHelpUrl = String.fromEnvironment('CODING_HELPER_API_URL');

final dio = Dio(
  BaseOptions(
    baseUrl: '$codeHelpUrl/api',
  ),
);

final _API = CodingHelperApi(dio: dio, interceptors: [BearerInterceptor()]);

final PROBLEMS_API = _API.getProblemApi();
final CATEGORIES_API = _API.getCategoryApi();
final CONTESTS_API = _API.getContestsApi();
final CODE_RUNNER_API = _API.getCodeRunnerApi();
final SUBMISSIONS_API = _API.getSubmissionApi();
final USER_API = _API.getUserApi();
