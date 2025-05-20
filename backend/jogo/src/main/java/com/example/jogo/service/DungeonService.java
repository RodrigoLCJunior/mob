/*
 ** Task..: 76 - Criação/Modificação das Classes para Wave
 ** Data..: 16/05/2025
 ** Autor.: Filipe Augusto
 ** Motivo: Criar Classes para Gerenciamento de Waves/Dungeons.
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Dungeon;
import com.example.jogo.repository.DungeonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class DungeonService {

    @Autowired
    private DungeonRepository dungeonRepository;

    public Dungeon criarDungeon(Dungeon dungeon) {
        Dungeon criada = dungeonRepository.save(dungeon);
        if (criada == null || criada.getId() == null) {
            throw new RuntimeException("Erro ao criar a dungeon");
        }
        return criada;
    }

    public Dungeon buscarDungeonPorId(Long id) {
        return dungeonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dungeon não encontrada com o ID: " + id));
    }

    public Dungeon atualizarDungeon(Long id, Dungeon atualizada) {
        Dungeon existente = dungeonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dungeon não encontrada para atualizar: " + id));

        existente.setNome(atualizada.getNome());
        existente.setQtdWaves(atualizada.getQtdWaves());
        existente.setImagemDungeon(atualizada.getImagemDungeon());

        Dungeon salva = dungeonRepository.save(existente);
        if (salva == null) {
            throw new RuntimeException("Erro ao atualizar a dungeon");
        }
        return salva;
    }

    public void deletarDungeon(Long id) {
        Dungeon dungeon = dungeonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dungeon não encontrada para exclusão: " + id));

        dungeonRepository.delete(dungeon);
    }
}
