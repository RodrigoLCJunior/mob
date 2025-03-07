package com.example.jogo.repository;

import com.example.jogo.model.Usuarios;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.UUID;

public interface UsuarioRepository extends JpaRepository<Usuarios, UUID> {
    Optional<Usuarios> findByEmail(String email);
}
