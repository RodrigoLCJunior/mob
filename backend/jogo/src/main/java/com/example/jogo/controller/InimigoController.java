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
    public ResponseEntity<List<Inimigo>> buscaTodosInimigos(){
        List<Inimigo> inimigosList = inimigoService.findAll();
        if (inimigosList.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(inimigosList);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Inimigo> buscarInimigoPorId(@PathVariable int id){
        Inimigo inimigo = inimigoService.findById(id).get();
        if (inimigo == null){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(inimigo);
    }

    @PostMapping("/criar-inimigo")
    public ResponseEntity<Inimigo> criarInimigo(@RequestBody Inimigo inimigo){
        Inimigo inimigoNovo = inimigoService.salvarInimigo(inimigo);
        if (inimigoNovo == null){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(inimigoNovo);
    }

    @PutMapping("/{id}/modificar")
    public ResponseEntity<Inimigo> updateInimigo(@PathVariable int id, @RequestBody Inimigo inimigoDetails) {
        Inimigo inimigoExistente = inimigoService.modificarInimigo(id, inimigoDetails);
        if (inimigoExistente != null) {
            return ResponseEntity.ok(inimigoExistente);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}/deletar-inimigo")
    public ResponseEntity<?> deleteInimigo(@PathVariable int id) {
        Optional<Inimigo> inimigo = inimigoService.findById(id);
        if (inimigo.isPresent()) {
            inimigoService.deletarInimigoPorId(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

}
