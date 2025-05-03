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

    @GetMapping
    public ResponseEntity<List<Avatar>> listarAvatares() {
        List<Avatar> avatares = avatarService.listarAvatares();
        return ResponseEntity.ok(avatares);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Avatar> buscarAvatar(@PathVariable UUID id) {
        Avatar avatar = avatarService.buscarAvatarPorId(id);
        if (avatar == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(avatar);
    }

    @PostMapping
    public ResponseEntity<?> criarAvatar(@RequestBody Avatar avatarNovo) {
        try {
            Avatar criado = avatarService.criarAvatar(avatarNovo);
            return ResponseEntity.status(201).body(criado);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro interno ao criar avatar");
        }
    }

    @PostMapping("/{id}/dano")
    public ResponseEntity<?> aplicarDano(@PathVariable UUID id, @RequestBody int dano) {
        Avatar avatar = avatarService.aplicarDano(id, dano);
        if (avatar == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(avatar);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> modificarAvatar(@PathVariable UUID id, @RequestParam int hp, @RequestParam int danoBase) {
        try {
            Avatar atualizado = avatarService.modificarAvatar(id, hp, danoBase);
            if (atualizado == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(atualizado);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro ao modificar avatar");
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletarAvatar(@PathVariable UUID id) {
        try {
            avatarService.deletarAvatarPorId(id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erro ao deletar avatar");
        }
    }
}
