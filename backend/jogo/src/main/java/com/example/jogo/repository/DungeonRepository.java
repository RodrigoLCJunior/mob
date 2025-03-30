/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 15/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Adaptar o maximo a dungeon para o Usuario
 ** Obs...:
 */

package com.example.jogo.repository;

import com.example.jogo.model.Dungeon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DungeonRepository extends JpaRepository<Dungeon, Integer> {
}
