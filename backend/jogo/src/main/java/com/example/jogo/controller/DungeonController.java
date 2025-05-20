/*
 ** Task..: 76 - Criação/Modificação das Classes para Wave
 ** Data..: 16/05/2025
 ** Autor.: Filipe Augusto
 ** Motivo: Criar Classes para Gerenciamento de Waves/Dungeons.
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Dungeon;
import com.example.jogo.service.DungeonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dungeons")
public class DungeonController {

    @Autowired
    private DungeonService dungeonService;

    @PostMapping
    public ResponseEntity<Dungeon> criarDungeon(@RequestBody Dungeon dungeon) {
        Dungeon criada = dungeonService.criarDungeon(dungeon);
        return ResponseEntity.ok(criada);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Dungeon> buscarPorId(@PathVariable Long id) {
        Dungeon dungeon = dungeonService.buscarDungeonPorId(id);
        return ResponseEntity.ok(dungeon);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Dungeon> atualizarDungeon(@PathVariable Long id, @RequestBody Dungeon dungeon) {
        Dungeon atualizada = dungeonService.atualizarDungeon(id, dungeon);
        return ResponseEntity.ok(atualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarDungeon(@PathVariable Long id) {
        dungeonService.deletarDungeon(id);
        return ResponseEntity.noContent().build();
    }
}
