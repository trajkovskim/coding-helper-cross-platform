package mk.com.codehelp.core.api.admin.rest.model;

import lombok.Builder;
import lombok.Getter;
import org.springframework.core.io.Resource;

import java.util.List;

@Getter
@Builder
public class CodeRunnerRequest {

  String runnerCode;
  String language;
  String code;
  List<Resource> testCases;
}
