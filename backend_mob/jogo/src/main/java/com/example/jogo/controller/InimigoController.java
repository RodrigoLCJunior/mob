package com.example.jogo.controller;

import com.example.jogo.model.Inimigo;
import com.example.jogo.service.InimigoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/inimigos")
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class InimigoController {

    @Autowired
    private InimigoService inimigoService;

    @GetMapping
    public ResponseEntity<List<Inimigo>> buscaTodosInimigos() {
        List<Inimigo> inimigosList = inimigoService.findAll();
        if (inimigosList.isEmpty()) {
            return ResponseEntity.noContent().build(); // 204
        }
        return ResponseEntity.ok(inimigosList); // 200
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> buscarInimigoPorId(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<Inimigo> inimigoOpt = inimigoService.findById(id);
            if (inimigoOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Inimigo não encontrado");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
            }
            response.put("success", true);
            response.put("inimigo", inimigoOpt.get());
            return ResponseEntity.ok(response); // 200
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @PostMapping("/criar-inimigo")
    public ResponseEntity<Map<String, Object>> criarInimigo(@RequestBody Inimigo inimigo) {
        Map<String, Object> response = new HashMap<>();
        try {
            Inimigo inimigoNovo = inimigoService.salvarInimigo(inimigo);
            response.put("success", true);
            response.put("message", "Inimigo criado com sucesso");
            response.put("inimigo", inimigoNovo);
            return new ResponseEntity<>(response, HttpStatus.CREATED); // 201
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao criar inimigo: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @PutMapping("/{id}/modificar")
    public ResponseEntity<Map<String, Object>> updateInimigo(@PathVariable Long id, @RequestBody Inimigo inimigoDetails) {
        Map<String, Object> response = new HashMap<>();
        try {
            Inimigo inimigoAtualizado = inimigoService.modificarInimigo(id, inimigoDetails);
            if (inimigoAtualizado == null) {
                response.put("success", false);
                response.put("message", "Inimigo não encontrado");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
            }
            response.put("success", true);
            response.put("message", "Inimigo atualizado com sucesso");
            response.put("inimigo", inimigoAtualizado);
            return ResponseEntity.ok(response); // 200
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro ao atualizar inimigo: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    // Endpoint para adicionar uma carta ao deck do Inimigo
    @PostMapping("/{id}/deck/add")
    public ResponseEntity<Map<String, Object>> adicionarCartaAoDeck(
            @PathVariable Long id,
            @RequestParam("numeroCarta") Long numeroCarta) {
        Map<String, Object> response = new HashMap<>();
        try {
            Inimigo inimigo = inimigoService.adicionarCartaAoDeckPorNumero(id, numeroCarta);
            response.put("success", true);
            response.put("message", "Carta adicionada ao deck com sucesso");
            response.put("Inimigo", inimigo);
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (IllegalStateException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao adicionar carta: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @DeleteMapping("/{id}/deletar-inimigo")
    public ResponseEntity<Map<String, Object>> deleteInimigo(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<Inimigo> inimigo = inimigoService.findById(id);
            if (inimigo.isEmpty()) {
                response.put("success", false);
                response.put("message", "Inimigo não encontrado");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
            }
            inimigoService.deletarInimigoPorId(id);
            response.put("success", true);
            response.put("message", "Inimigo deletado com sucesso");
            return ResponseEntity.ok(response); // 200
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao deletar inimigo: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }
}
