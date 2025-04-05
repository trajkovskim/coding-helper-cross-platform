package mk.com.codehelp.core.service.util;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Component;

import mk.com.codehelp.core.domain.model.Problem;

@Component
public class ProblemUtil {

  public  Optional<Problem.Code> getCodeByLanguage(List<Problem.Code> codes, String language) {
    return codes.stream()
        .filter(code -> language.equals(code.getLanguage()))
        .findAny();
  }
}
