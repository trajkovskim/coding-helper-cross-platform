package mk.com.codehelp.core.service.util;

import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.nio.file.Files;

import org.springframework.stereotype.Component;

@Component
public class CodeUtil {

  public String mergeCode(String code, String runnerCode) {

    return code + "\n" + runnerCode;
  }

  public File createTempCodeFile(String code, String ext) throws IOException {

    File tempCodeFile = File.createTempFile("code-", ext);
    try (Writer writer = Files.newBufferedWriter(tempCodeFile.toPath())) {
      writer.write(code);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }

    return tempCodeFile;
  }

  public boolean deleteFile(File file) {

    boolean deleted = file.delete();

    if (!deleted) {
      file.deleteOnExit();
    }

    return deleted;
  }
}
