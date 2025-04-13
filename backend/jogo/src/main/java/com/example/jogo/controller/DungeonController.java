/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 15/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Adaptar o maximo a dungeon para o Usuario
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Dungeon;
import com.example.jogo.service.DungeonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/dungeon")
public class DungeonController {

    @Autowired
    private DungeonService dungeonService;

    @GetMapping("/{id}")
    private ResponseEntity<Dungeon> acharDungeonPorId(@PathVariable int id){
        Dungeon dungeon = dungeonService.getDungeon(id);
        if (dungeon == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(dungeon);
    }

    @GetMapping
    private ResponseEntity<List<Dungeon>> acharTodasAsDungeuns(){
        List<Dungeon> dungeonList = dungeonService.buscarTodasDungeons();
        if (dungeonList.isEmpty()){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(dungeonList);
    }

    @PostMapping("/criar-dungeun")
    private ResponseEntity<Dungeon> criarDungeon(@RequestBody Dungeon dungeon){
        Dungeon dungeonNovo = dungeonService.criarDungeon(dungeon.getNome(), dungeon.getNumeroWaves());
        if (dungeon == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(dungeonNovo);
    }

    @PostMapping("/{id}/concluir")
    private ResponseEntity<?> concluirDungeon(@PathVariable int id) {
        dungeonService.concluirDungeon(id);
        return ResponseEntity.noContent().build();
    }

}
