/*
 ** Task.....: 15 - Reformular a Classe Usuario
 ** Motivo...: Repositorio do Avatar
 ** Usuario..: Rodrigo Luiz
 ** Data.....: 15/03/2025
 ** Obs......:
 */

package com.example.jogo.repository;

import com.example.jogo.model.Avatar;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AvatarRepository extends JpaRepository<Avatar, UUID> {
}
