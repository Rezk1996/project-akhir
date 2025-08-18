package com.boniewijaya2021.springboot.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Springboot RestApi Postgres")
                        .description("Springboot RestApi Postgres")
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("Springboot RestApi Postgres")
                                .url("www.boniewijaya.com")
                                .email("admin@boniewijaya.com")));
    }
}