import mk.com.codehelp.core.CodingHelperApplication;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = CodingHelperApplication.class)
@ActiveProfiles("test")
@AutoConfigureMockMvc
public class OpenApiSpecGenerator {

  private final String RESOURCES_PATH = "../code-help-core-api-docs/src/main/resources";
  private final String FILE_NAME = "code-help-core-api.yaml";

  private final Path FILE_PATH = Path.of(RESOURCES_PATH, FILE_NAME);

  @Autowired
  private MockMvc mockMvc;

  @Test
  @Disabled
  void generateOpenApiSpec() throws Exception {
    String openApiSpec = getOpenApiYamlSpec();

    Files.writeString(FILE_PATH, openApiSpec, StandardCharsets.UTF_8);
  }

  private String getOpenApiYamlSpec() throws Exception {
    return getOpenApiSpec(".yaml");
  }

  private String getOpenApiSpec(String ext) throws Exception {
    MvcResult mvcResult = this.mockMvc.perform(get("/v3/api-docs" + ext))
        .andExpect(status().isOk())
        .andReturn();

    MockHttpServletResponse response = mvcResult.getResponse();
    return response.getContentAsString();
  }

}
