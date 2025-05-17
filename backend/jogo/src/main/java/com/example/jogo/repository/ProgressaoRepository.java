/*
 ** Task..: 18 - Criação e formulação da classe Progresso
 ** Data..: 18/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Progressão
 ** Obs...:
 */

package com.example.jogo.repository;

import com.example.jogo.model.Progressao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ProgressaoRepository extends JpaRepository<Progressao, UUID> {
    Progressao findByAvatarId(UUID avatarId);
}
