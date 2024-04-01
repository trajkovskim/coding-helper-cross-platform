package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.File;
import mk.com.codehelp.core.rest.admin.model.ProblemDetailAllOfTestCases;
import org.mapstruct.Mapper;
import org.springframework.boot.web.server.MimeMappings;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Mapper
public interface FileMapper {

  default File convertResourceToFile(Resource resource) throws IOException {
    String type = "unknown";

    int index = Objects.requireNonNull(resource.getFilename()).lastIndexOf(".");
    if (index != -1) {
      String extension = resource.getFilename().substring(index + 1);
      type = MimeMappings.DEFAULT.get(extension);
    }

    File file = new File();
    file.setName(resource.getFilename());
    file.setType(type);
    file.setData(resource.getInputStream().readAllBytes());

    return file;
  }

  default String convertDomainFileToString(File file) throws IOException {
    return new String(file.getData(), StandardCharsets.UTF_8);
  }

  default List<ProblemDetailAllOfTestCases> convert(List<File> testCases) throws IOException {

    var testCasesMap = testCases.stream().collect(Collectors.toMap(File::getName,file -> file));

    return testCasesMap.entrySet().stream()
        .filter(entry -> entry.getKey().startsWith("IN"))
        .map(entry -> {
          String outFileKey = entry.getKey().replace("IN", "OUT");

          File inFile = entry.getValue();
          File outFile = testCasesMap.get(outFileKey);

          Long index = Long.parseLong(inFile.getName().substring(2));
          try {
            return new ProblemDetailAllOfTestCases()
                .id(index)
                .in(convertDomainFileToString(inFile))
                .out(convertDomainFileToString(outFile));
          } catch (IOException e) {
            throw new RuntimeException(e);
          }})
        .collect(Collectors.toList());
  }
}
