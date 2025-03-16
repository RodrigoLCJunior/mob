/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar controller Avatar para usar no Combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.service.AvatarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/avatar")
public class AvatarController {

    @Autowired
    private AvatarService avatarService;

    @GetMapping("/{id}")
    private Avatar acharAvatar(@PathVariable UUID id){
        return avatarService.getAvatar(id);
    }

    @PostMapping("/{id}/dano")
    private void aplicarDano(@PathVariable UUID id, @RequestParam int dano){
        avatarService.aplicarDano(id, dano);
    }

    @PutMapping("/{id}")
    public Avatar modificarAvatar(@PathVariable UUID id, int hp, @RequestParam int danoBase){
        return avatarService.modificarAvatar(id, hp, danoBase);
    }

}
