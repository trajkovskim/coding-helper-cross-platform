// Openapi Generator last run: : 2025-05-11T19:07:33.609668
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';
import 'package:coding_helper_cross_platform/env.dart' as env;

@Openapi(
  additionalProperties: DioProperties(pubName: 'coding_helper_api'),
  inputSpec: InputSpec(path: env.CODING_HELPER_OPENAPI_SPEC),
  generatorName: Generator.dio,
  forceAlwaysRun: true,
  // overwriteExistingFiles: true,
  outputDirectory: 'api/coding_helper_api',
)
class CodingHelperApiConfiguration{}

@Openapi(
  additionalProperties: DioProperties(pubName: 'coding_helper_forum_api'),
  inputSpec: InputSpec(path: env.CODING_HELPER_OPENAPI_FORUM_SPEC),
  generatorName: Generator.dio,
  forceAlwaysRun: true,
  // overwriteExistingFiles: true,
  outputDirectory: 'api/coding_helper_forum_api',
)
class CodingHelperForumApiConfiguration{}