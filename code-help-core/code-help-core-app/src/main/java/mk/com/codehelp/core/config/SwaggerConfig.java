package mk.com.codehelp.core.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
  @Bean
  public OpenAPI api() {
    return new OpenAPI()
        .info(new Info().title("Coding helper API")
            .description("Coding helper application")
            .version("1.0.0"))
        .components(new Components().addSecuritySchemes(
            "Authorization_JWT",
            new SecurityScheme()
                .scheme("bearer")
                .bearerFormat("JWT").type(SecurityScheme.Type.HTTP)
                .in(SecurityScheme.In.HEADER)))
        .addSecurityItem(new SecurityRequirement().addList("Authorization_JWT"));
  }

}
