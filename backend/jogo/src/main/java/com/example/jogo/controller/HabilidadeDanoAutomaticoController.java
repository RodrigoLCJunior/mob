/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.HabilidadeDanoAutomatico;
import com.example.jogo.service.HabilidadeDanoAutomaticoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/habilidades-dano-automatico")
public class HabilidadeDanoAutomaticoController {

    @Autowired
    private HabilidadeDanoAutomaticoService habilidadeDanoAutomaticoService;

    @GetMapping("/{id}")
    public ResponseEntity<HabilidadeDanoAutomatico> obterHabilidadePorId(@PathVariable int id) {
        Optional<HabilidadeDanoAutomatico> habilidade = habilidadeDanoAutomaticoService.buscarHabilidadePorId(id);
        return habilidade.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<HabilidadeDanoAutomatico> criarHabilidade(@RequestBody HabilidadeDanoAutomatico habilidade) {
        HabilidadeDanoAutomatico novaHabilidade = habilidadeDanoAutomaticoService.salvarHabilidade(habilidade);
        return ResponseEntity.ok(novaHabilidade);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarHabilidade(@PathVariable int id) {
        habilidadeDanoAutomaticoService.deletarHabilidade(id);
        return ResponseEntity.noContent().build();
    }
}
