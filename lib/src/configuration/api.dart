import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';
import 'package:coding_helper_cross_platform/env.dart' as env;

@Openapi(
  additionalProperties: DioProperties(pubName: 'coding_helper_api'),
  inputSpecFile: env.CODING_HELPER_OPENAPI_SPEC,
  generatorName: Generator.dio,
  alwaysRun: true,
  outputDirectory: 'api/coding_helper_api',
)
class CodingHelperApiConfigration extends OpenapiGeneratorConfig {}
