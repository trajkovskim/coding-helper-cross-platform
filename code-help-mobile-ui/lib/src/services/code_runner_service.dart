import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/services/api.dart';

class CodeRunnerService {
  const CodeRunnerService();

  Future<String> runCode(RunCodeRequest request) {
    return CODE_RUNNER_API
        .runCode(runCodeRequest: request)
        .then((value) => value.data ?? '');
  }
}
