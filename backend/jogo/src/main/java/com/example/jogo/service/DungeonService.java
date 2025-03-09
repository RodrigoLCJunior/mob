/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Dungeon para usar no Combate
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Dungeon;
import com.example.jogo.repository.DungeonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DungeonService {

    @Autowired
    private DungeonRepository dungeonRepository;

    public List<Dungeon> findAll() {
        return dungeonRepository.findAll();
    }

    public Optional<Dungeon> findById(int id) {
        return dungeonRepository.findById(id);
    }

    public Dungeon salvarDungeon(Dungeon dungeon) {
        return dungeonRepository.save(dungeon);
    }
}
