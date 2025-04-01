package com.example.jogo.controller;

import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.service.MoedaPermanenteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/moeda-permanente")
public class MoedaPermanenteController {

    @Autowired
    private MoedaPermanenteService moedaPermanenteService;

    @PostMapping("/criar")
    public ResponseEntity<MoedaPermanente> criarMoedaPermanente() {
        MoedaPermanente moedaPermanente = moedaPermanenteService.criarMoedaPermanente();
        return ResponseEntity.ok(moedaPermanente);
    }

    @GetMapping("/buscar/{id}")
    public ResponseEntity<MoedaPermanente> buscarMoedaPermanente(@PathVariable UUID id) {
        MoedaPermanente moedaPermanente = moedaPermanenteService.buscarMoedaPermanente(id);
        return ResponseEntity.ok(moedaPermanente);
    }

    @PutMapping("/modificar/{id}")
    public ResponseEntity<MoedaPermanente> modificarMoedaPermanente(@PathVariable UUID id, @RequestParam int quantidade) {
        MoedaPermanente moedaPermanente = moedaPermanenteService.modificarMoedaPermanente(id, quantidade);
        return ResponseEntity.ok(moedaPermanente);
    }

    @DeleteMapping("/deletar/{id}")
    public ResponseEntity<Void> deletarMoedaPermanente(@PathVariable UUID id) {
        moedaPermanenteService.deletarMoedaPermanente(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/ganhar/{id}")
    public ResponseEntity<MoedaPermanente> ganharMoedas(@PathVariable UUID id, @RequestParam int quantidade) {
        MoedaPermanente moedaPermanente = moedaPermanenteService.ganharMoedas(id, quantidade);
        return ResponseEntity.ok(moedaPermanente);
    }

    @PutMapping("/gastar/{id}")
    public ResponseEntity<MoedaPermanente> gastarMoedas(@PathVariable UUID id, @RequestParam int quantidade) {
        MoedaPermanente moedaPermanente = moedaPermanenteService.gastarMoedas(id, quantidade);
        return ResponseEntity.ok(moedaPermanente);
    }
}
