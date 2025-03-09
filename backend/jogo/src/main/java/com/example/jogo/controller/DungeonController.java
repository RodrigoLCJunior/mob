/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Dungeon para usar no Combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Dungeon;
import com.example.jogo.service.DungeonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("api/Dungeon")
public class DungeonController {

    @Autowired
    private DungeonService dungeonService;

    @GetMapping
    public List<Dungeon> buscarTodosDungeons(){
        return dungeonService.findAll();
    }

    @GetMapping("/{id}")
    public Optional<Dungeon> buscarDungeonById(@PathVariable int id){
        return dungeonService.findById(id);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Dungeon> updateDungeon(@PathVariable int id, @RequestBody Dungeon dungeonDetails) {
        Optional<Dungeon> optionalDungeon = dungeonService.findById(id);
        if (optionalDungeon.isPresent()) {
            Dungeon dungeon = optionalDungeon.get();
            dungeon.setNome(dungeonDetails.getNome());
            dungeon.setWaves(dungeonDetails.getWaves());
            return ResponseEntity.ok(dungeonService.salvarDungeon(dungeon));
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
