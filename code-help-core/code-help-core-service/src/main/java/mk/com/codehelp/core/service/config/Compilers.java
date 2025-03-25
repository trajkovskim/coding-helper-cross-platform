package mk.com.codehelp.core.service.config;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.Map;

@Configuration
@ConfigurationProperties
@Getter
@Setter
public class Compilers {

  @RequiredArgsConstructor
  @Getter
  public static class SingleCompiler {
    private final String compiler;
    private final String ext;
  }

  private Map<String, SingleCompiler> compilers;
}
