/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.HabilidadeAumentoDano;
import com.example.jogo.service.HabilidadeAumentoDanoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/habilidades-aumento-dano")
public class HabilidadeAumentoDanoController {

    @Autowired
    private HabilidadeAumentoDanoService habilidadeAumentoDanoService;

    @GetMapping("/{id}")
    private ResponseEntity<HabilidadeAumentoDano> obterHabilidadePorId(@PathVariable int id) {
        Optional<HabilidadeAumentoDano> habilidade = habilidadeAumentoDanoService.buscarHabilidadePorId(id);
        return habilidade.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<HabilidadeAumentoDano> criarHabilidade(@RequestBody HabilidadeAumentoDano habilidade) {
        HabilidadeAumentoDano novaHabilidade = habilidadeAumentoDanoService.salvarHabilidade(habilidade);
        return ResponseEntity.ok(novaHabilidade);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarHabilidade(@PathVariable int id) {
        habilidadeAumentoDanoService.deletarHabilidade(id);
        return ResponseEntity.noContent().build();
    }
}
