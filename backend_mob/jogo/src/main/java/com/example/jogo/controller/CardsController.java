package com.example.jogo.controller;

import com.example.jogo.model.Cards;
import com.example.jogo.service.CardsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/cards")
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class CardsController {

    @Autowired
    private CardsService cardsService;

    // Buscar todas as cartas
    @GetMapping
    public ResponseEntity<List<Cards>> acharTodasCards() {
        List<Cards> cardsList = cardsService.acharTodasCards();
        if (cardsList.isEmpty()) {
            return ResponseEntity.noContent().build(); // 204
        }
        return ResponseEntity.ok(cardsList); // 200
    }

    // Buscar carta por ID
    @GetMapping("/{id}")
    public ResponseEntity<?> acharCardPorId(@PathVariable Long id) {
        try {
            Cards card = cardsService.acharCardPorId(id);
            return ResponseEntity.ok(card); // 200
        } catch (NoSuchElementException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Carta não encontrada");
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Erro interno: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    // Criar nova carta
    @PostMapping("/criar")
    public ResponseEntity<Map<String, Object>> criarCard(@RequestBody Cards card) {
        Map<String, Object> response = new HashMap<>();
        try {
            Cards novaCard = cardsService.criarCard(card);
            response.put("success", true);
            response.put("message", "Carta criada com sucesso");
            response.put("card", novaCard);
            return new ResponseEntity<>(response, HttpStatus.CREATED); // 201
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao criar carta: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    // Modificar carta existente
    @PutMapping("/{id}/alterar")
    public ResponseEntity<Map<String, Object>> modificarCard(@PathVariable Long id, @RequestBody Cards card) {
        Map<String, Object> response = new HashMap<>();
        try {
            Cards cardAtualizada = cardsService.modificarCards(id, card);
            if (cardAtualizada == null) {
                response.put("success", false);
                response.put("message", "Carta não encontrada");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
            }
            response.put("success", true);
            response.put("message", "Carta atualizada com sucesso");
            response.put("card", cardAtualizada);
            return ResponseEntity.ok(response); // 200
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao modificar carta: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    // Deletar carta
    @DeleteMapping("/{id}/deletar")
    public ResponseEntity<Map<String, Object>> deletarCard(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            cardsService.deletarCard(id);
            response.put("success", true);
            response.put("message", "Carta deletada com sucesso");
            return ResponseEntity.ok(response); // 200
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao deletar carta: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }
}
