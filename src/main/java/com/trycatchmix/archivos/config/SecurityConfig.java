package com.trycatchmix.archivos.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.trycatchmix.archivos.security.JwtAuthFilter;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import jakarta.servlet.DispatcherType;

import java.util.Map;

@Configuration
@EnableMethodSecurity
@EnableConfigurationProperties(JwtProperties.class)
public class SecurityConfig {

    private final JwtAuthFilter jwtFilter;
    private final Environment env;
    private final ObjectMapper mapper = new ObjectMapper();

    public SecurityConfig(JwtAuthFilter jwtFilter, Environment env) {
        this.jwtFilter = jwtFilter;
        this.env = env;
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        boolean dev = env.matchesProfiles("dev");

        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(AbstractHttpConfigurer::disable)
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(reg -> {
                // El reenvío interno a /error va SIN el token: JwtAuthFilter es un
                // OncePerRequestFilter y, por defecto, no corre en el dispatch de
                // error. Sin esta línea, cualquier 500 o 404 llegaba al navegador
                // disfrazado de 401 «Necesitas iniciar sesión», que manda a buscar
                // el fallo justo donde no está.
                reg.dispatcherTypeMatchers(DispatcherType.ERROR).permitAll();
                reg.requestMatchers("/api/auth/register", "/api/auth/login",
                        "/api/auth/refresh", "/api/auth/logout").permitAll();
                // Los endpoints de desarrollo solo existen y se abren en dev.
                if (dev) reg.requestMatchers("/api/dev/**").permitAll();
                reg.requestMatchers("/api/admin/**", "/api/mesa/**").hasRole("DM");
                reg.anyRequest().authenticated();
            })
            .exceptionHandling(e -> e.authenticationEntryPoint((req, res, ex) -> {
                res.setStatus(HttpStatus.UNAUTHORIZED.value());
                res.setContentType(MediaType.APPLICATION_JSON_VALUE);
                mapper.writeValue(res.getWriter(),
                        Map.of("error", "UNAUTHENTICATED", "message", "Necesitas iniciar sesión."));
            }))
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
