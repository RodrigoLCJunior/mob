/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 15/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Adaptar o maximo a dungeon para o Usuario
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Dungeon;
import com.example.jogo.service.DungeonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/dungeon")
public class DungeonController {

    @Autowired
    private DungeonService dungeonService;

    @GetMapping("/{id}")
    private Dungeon acharDungeonPorId(@PathVariable int id){
        return dungeonService.getDungeon(id);
    }

    @GetMapping("/usuario/{usuarioId}")
    private List<Dungeon> getDungeonsByUsuario(@PathVariable UUID usuarioId){
        return dungeonService.getDungeonsByUsuario(usuarioId);
    }

    @PostMapping("/{id}/concluir")
    public void concluirDungeon(@PathVariable int id) {
        dungeonService.concluirDungeon(id);
    }

}
