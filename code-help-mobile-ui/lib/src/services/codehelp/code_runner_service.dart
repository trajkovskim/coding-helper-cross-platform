import 'package:coding_helper_api/coding_helper_api.dart';

import 'api.dart';

class CodeRunnerService {
  const CodeRunnerService();

  Future<String> runCode(int problemId, CodeRunnerRequest request) {
    return CODE_RUNNER_API
        .runCode(problemId: problemId, codeRunnerRequest: request)
        .then((value) => value.data?.message ?? '');
  }
}
