/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Inimigo;
import com.example.jogo.service.InimigoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/inimigos")
public class InimigoController {

    @Autowired
    private InimigoService inimigoService;

    @GetMapping
    public List<Inimigo> buscaTodosInimigos(){
        return inimigoService.findAll();
    }

    @GetMapping("/{id}")
    public Optional<Inimigo> buscarInimigoPorId(@PathVariable int id){
        return inimigoService.findById(id);
    }

    @PostMapping
    public Inimigo criarInimigo(@RequestBody Inimigo inimigo){
        return inimigoService.salvarInimigo(inimigo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Inimigo> updateInimigo(@PathVariable int id, @RequestBody Inimigo inimigoDetails) {
        Optional<Inimigo> inimigo = inimigoService.findById(id);
        if (inimigo.isPresent()) {
            Inimigo existingInimigo = inimigo.get();
            existingInimigo.setHp(inimigoDetails.getHp());
            existingInimigo.setDanoBase(inimigoDetails.getDanoBase());
            existingInimigo.setTimeToHit(inimigoDetails.getTimeToHit());
            existingInimigo.setRecompensa(inimigoDetails.getRecompensa());
            existingInimigo.setTipo(inimigoDetails.getTipo());
            Inimigo updatedInimigo = inimigoService.salvarInimigo(existingInimigo);
            return ResponseEntity.ok(updatedInimigo);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteInimigo(@PathVariable int id) {
        Optional<Inimigo> inimigo = inimigoService.findById(id);
        if (inimigo.isPresent()) {
            inimigoService.deletarInimigoPorId(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

}
