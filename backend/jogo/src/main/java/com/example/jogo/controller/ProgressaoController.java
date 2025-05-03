package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Progressao;
import com.example.jogo.service.AvatarService;
import com.example.jogo.service.ProgressaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/progressao")
public class ProgressaoController {

    @Autowired
    private ProgressaoService progressaoService;

    @Autowired
    private AvatarService avatarService;

    @GetMapping
    public ResponseEntity<List<Progressao>> buscarTodasProgressoes() {
        List<Progressao> progressoes = progressaoService.acharTodasProgressoes();
        return ResponseEntity.ok(progressoes);
    }

    @GetMapping("/{avatarId}/avatar-id")
    public ResponseEntity<?> buscarProgressaoPorAvatar(@PathVariable UUID avatarId) {
        Avatar avatar = avatarService.buscarAvatarPorId(avatarId);
        if (avatar == null) {
            return ResponseEntity.status(404).body("Avatar não encontrado");
        }

        Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
        return ResponseEntity.ok(progressao);
    }

    @PostMapping("/{avatarId}/adicionarMoedasTemporarias")
    public ResponseEntity<?> adicionarMoedasTemporarias(
            @PathVariable UUID avatarId,
            @RequestParam int quantidade) {

        try {
            Avatar avatar = avatarService.buscarAvatarPorId(avatarId);
            if (avatar == null) {
                return ResponseEntity.status(404).body("Avatar não encontrado");
            }

            progressaoService.adicionarMoedasTemporarias(avatar, quantidade);
            Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
            return ResponseEntity.ok(progressao);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro ao adicionar moedas temporárias");
        }
    }

    @PostMapping("/{avatarId}/adicionarClique")
    public ResponseEntity<?> adicionarClique(@PathVariable UUID avatarId) {
        try {
            Avatar avatar = avatarService.buscarAvatarPorId(avatarId);
            if (avatar == null) {
                return ResponseEntity.status(404).body("Avatar não encontrado");
            }

            progressaoService.adicionarClique(avatar);
            Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
            return ResponseEntity.ok(progressao);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro ao adicionar clique");
        }
    }

    @PostMapping("/{avatarId}/adicionarInimigoDerrotado")
    public ResponseEntity<?> adicionarInimigoDerrotado(@PathVariable UUID avatarId) {
        try {
            Avatar avatar = avatarService.buscarAvatarPorId(avatarId);
            if (avatar == null) {
                return ResponseEntity.status(404).body("Avatar não encontrado");
            }

            progressaoService.adicionarInimigoDerrotado(avatar);
            Progressao progressao = progressaoService.buscarProgressaoPorAvatar(avatar);
            return ResponseEntity.ok(progressao);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro ao adicionar inimigo derrotado");
        }
    }
}
