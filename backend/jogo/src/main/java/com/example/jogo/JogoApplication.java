package com.example.jogo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.server.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class JogoApplication {

	public static void main(String[] args) {
		SpringApplication.run(JogoApplication.class, args);
	}

	@Bean
	public WebServerFactoryCustomizer<ConfigurableServletWebServerFactory> webServerFactoryCustomizer() {
		return factory -> {
			String port = System.getenv("PORT");
			factory.setPort(port != null && !port.isEmpty() ? Integer.parseInt(port) : 9090);
		};
	}
}
