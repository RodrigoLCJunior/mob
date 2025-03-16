/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 15/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Adaptar o maximo a dungeon para o Usuario
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Dungeon;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.DungeonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class DungeonService {

    @Autowired
    private DungeonRepository dungeonRepository;

    public Dungeon getDungeon(int id) {
        return dungeonRepository.findById(id).orElse(null);
    }

    public List<Dungeon> getDungeonsByUsuario(UUID usuarioId) {
        return dungeonRepository.findByUsuarioId(usuarioId);
    }

    public void concluirDungeon(int dungeonId) {
        // Concluir a dungeon atual
        Dungeon dungeon = getDungeon(dungeonId);
        if (dungeon != null) {
            dungeon.setConcluida(true);
            dungeonRepository.save(dungeon);
        }

        // Desbloquear a próxima dungeon
        desbloquearProximaDungeon(dungeonId + 1);
    }

    private void desbloquearProximaDungeon(int proximaDungeonId) {
        // Buscar a próxima dungeon pelo ID
        Optional<Dungeon> proximaDungeon = dungeonRepository.findById(proximaDungeonId); // Precisa ser Optional, pois ele pode achar uma Dungeon null.

        // Desbloquear a próxima dungeon se ela existir
        if (proximaDungeon.isPresent()) {
            Dungeon dungeon = proximaDungeon.get();
            dungeon.setBloqueada(false);
            dungeonRepository.save(dungeon);
        }
    }
}
