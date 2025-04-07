/*
 ** Task..: 18 - Criação e formulação da classe Progresso
 ** Data..: 18/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Progressão
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Progressao;
import com.example.jogo.service.AvatarService;
import com.example.jogo.service.ProgressaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/progressao")
public class ProgressaoController {

    @Autowired
    private ProgressaoService progressaoService;

    @Autowired
    private AvatarService avatarService;

    @GetMapping("/{avatarId}")
    private ResponseEntity<Progressao> buscarProgressao(@PathVariable UUID avatarId){
        Avatar avatar = avatarService.getAvatar(avatarId);
        if (avatar == null){
            return ResponseEntity.notFound().build();
        }
        Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
        return ResponseEntity.ok(progressao);
    }

    @PostMapping("/{avatarId}/adicionarMoedasTemporarias")
    private ResponseEntity<Progressao> adicinarMoedasTemporarias(@PathVariable UUID avatarId, @RequestParam int quantidade){
        Avatar avatar = avatarService.getAvatar(avatarId);
        if (avatar == null){
            return ResponseEntity.notFound().build();
        }
        progressaoService.adicionarMoedasTemporarias(avatar, quantidade);
        Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
        return ResponseEntity.ok(progressao);
    }

    @PostMapping("/{avatarId}/adicionarClique")
    private ResponseEntity<Progressao> adicinarClique(@PathVariable UUID avatarId){
        Avatar avatar = avatarService.getAvatar(avatarId);
        if (avatar == null){
            return ResponseEntity.notFound().build();
        }
        progressaoService.adicionarClique(avatar);
        Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
        return ResponseEntity.ok(progressao);
    }

    @PostMapping("/{avatarId}/adicionarInimigoDerrotado")
    private ResponseEntity<Progressao> adicionarInimigoDerrotado(@PathVariable UUID avatarId){
        Avatar avatar = avatarService.getAvatar(avatarId);
        if (avatar == null){
            return ResponseEntity.notFound().build();
        }
        progressaoService.adicionarInimigoDerrotado(avatar);
        Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
        return ResponseEntity.ok(progressao);
    }
}
