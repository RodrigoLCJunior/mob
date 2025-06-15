/*
 ** Task..: 31 - Conexão Back e Front
 ** Data..: 03/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Segurnaça, autenticação, e criptografia
 ** Obs...:
 */

package com.example.jogo.config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        /*
                        .requestMatchers("/api/usuarios/criar", "/api/usuarios/login").permitAll() // Libera esses endpoints
                        .anyRequest().authenticated() // Protege os demais
                         */
                        .anyRequest().permitAll() // Libera tudo
                )
                .csrf(csrf -> csrf.disable()); // Desativa CSRF para testes

        return http.build();
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}