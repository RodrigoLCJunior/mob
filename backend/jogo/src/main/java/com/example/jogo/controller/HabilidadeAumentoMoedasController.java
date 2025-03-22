/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.HabilidadeAumentoMoedas;
import com.example.jogo.service.HabilidadeAumentoMoedasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/habilidades-aumento-moedas")
public class HabilidadeAumentoMoedasController {

    @Autowired
    private HabilidadeAumentoMoedasService habilidadeAumentoMoedasService;

    @GetMapping("/{id}")
    private ResponseEntity<HabilidadeAumentoMoedas> obterHabilidadePorId(@PathVariable int id) {
        Optional<HabilidadeAumentoMoedas> habilidade = habilidadeAumentoMoedasService.buscarHabilidadePorId(id);
        return habilidade.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    private ResponseEntity<HabilidadeAumentoMoedas> criarHabilidade(@RequestBody HabilidadeAumentoMoedas habilidade) {
        HabilidadeAumentoMoedas novaHabilidade = habilidadeAumentoMoedasService.salvarHabilidade(habilidade);
        return ResponseEntity.ok(novaHabilidade);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarHabilidade(@PathVariable int id) {
        habilidadeAumentoMoedasService.deletarHabilidade(id);
        return ResponseEntity.noContent().build();
    }
}
