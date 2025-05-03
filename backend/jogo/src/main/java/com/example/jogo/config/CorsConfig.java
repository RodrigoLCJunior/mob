/*
 ** Task..: 31 - Conexão Back e Front
 ** Data..: 03/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Conexão com o flutter
 ** Obs...:
 */

package com.example.jogo.config;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration // Indica que esta é uma classe de configuração do Spring
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // Aplica o CORS a todos os endpoints da API
                .allowedOrigins(
                        "http://localhost:8080",      // Para testes no navegador ou Flutter local
                        "http://10.0.2.2:8080"       // Para Flutter rodando em emulador Android
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // Métodos HTTP permitidos
                .allowedHeaders("*") // Permite todos os cabeçalhos nas requisições
                .allowCredentials(true) // Permite envio de cookies ou credenciais, se necessário
                .maxAge(3600); // Tempo em segundos que a configuração é cacheada (opcional)
    }
}
