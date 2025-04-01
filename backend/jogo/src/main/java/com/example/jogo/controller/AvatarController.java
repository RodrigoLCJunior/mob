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
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/avatar")
public class AvatarController {

    @Autowired
    private AvatarService avatarService;

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    @GetMapping
    private  ResponseEntity<List<Avatar>> acharTodosAvatar(){
        List<Avatar> avatarList = avatarService.todosAvatares();
        if (avatarList.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(avatarList);
    }

    @GetMapping("/{id}")
    private ResponseEntity<Avatar> acharAvatar(@PathVariable UUID id){
        Avatar avatar = avatarService.getAvatar(id);
        if (avatar == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(avatar);
    }

    @PostMapping("/{id}/dano")
    private ResponseEntity<?> aplicarDano(@PathVariable UUID id, @RequestBody int dano){
        avatarService.aplicarDano(id, dano);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Avatar> modificarAvatar(@PathVariable UUID id, @RequestBody int hp, @RequestBody int danoBase){
        Avatar avatar =  avatarService.modificarAvatar(id, hp, danoBase);
        if (avatar == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(avatar);
    }

}
