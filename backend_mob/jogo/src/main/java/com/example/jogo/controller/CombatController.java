/*
 ** Task..: 14 - Sistema de Combate no Backend
 ** Data..: 26/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar endpoints para gerenciamento de combate
 ** Obs...: Segue o padrão de respostas do UsuarioController
 */

package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.CombatState;
import com.example.jogo.model.Inimigo;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.InimigoRepository;
import com.example.jogo.repository.UsuarioRepository;
import com.example.jogo.service.CombatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/combat")
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class CombatController {

    @Autowired
    private CombatService combatService;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private InimigoRepository inimigoRepository;

    private final Random random = new Random();

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }

    @PostMapping("/start")
    public ResponseEntity<Map<String, Object>> startCombat(@RequestParam UUID playerId) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Log inicial
            System.out.println("Iniciando combate para o jogador com ID: " + playerId);

            // Validar se o jogador existe e possui avatar
            Usuarios usuario = usuarioRepository.findById(playerId)
                    .orElseThrow(() -> new IllegalArgumentException("Jogador não encontrado pelo ID: " + playerId));

            Avatar avatar = usuario.getAvatar();
            if (avatar == null) {
                System.out.println("Erro: Jogador não possui um avatar válido.");
                throw new IllegalStateException("Jogador não possui um avatar válido.");
            }

            // Buscar todos os inimigos e selecionar um aleatório
            List<Inimigo> allEnemies = new ArrayList<>(inimigoRepository.findAll());
            if (allEnemies.isEmpty()) {
                System.out.println("Erro: Nenhum inimigo encontrado.");
                throw new RuntimeException("Nenhum inimigo encontrado");
            }
            Inimigo enemy = allEnemies.get(random.nextInt(allEnemies.size()));

            // Logs detalhados do avatar e do inimigo selecionado
            System.out.println("Avatar selecionado: " + avatar.getId());
            System.out.println("Inimigo selecionado: " + enemy.getNome());

            // Preparar os dados para o frontend
            Map<String, Object> combatData = new HashMap<>();
            combatData.put("avatar", avatar);
            combatData.put("enemy", enemy);

            response.put("success", true);
            response.put("combatData", combatData);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            // Log detalhado do erro
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Erro ao iniciar combate: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping("/play-card")
    public ResponseEntity<Map<String, Object>> playCard(@RequestParam UUID playerId, @RequestParam Long cardId) {
        Map<String, Object> response = new HashMap<>();
        try {
            CombatState combatState = combatService.playCard(playerId, cardId);
            response.put("success", true);
            response.put("message", "Carta jogada com sucesso");
            response.put("combatState", combatState);
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (IllegalStateException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao jogar carta: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @PostMapping("/end-turn")
    public ResponseEntity<Map<String, Object>> endPlayerTurn(@RequestParam UUID playerId) {
        Map<String, Object> response = new HashMap<>();
        try {
            CombatState combatState = combatService.endPlayerTurn(playerId);
            response.put("success", true);
            response.put("message", "Turno finalizado com sucesso");
            response.put("combatState", combatState);
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (IllegalStateException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao finalizar turno: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @GetMapping("/state")
    public ResponseEntity<Map<String, Object>> getCombatState(@RequestParam UUID playerId) {
        Map<String, Object> response = new HashMap<>();
        try {
            CombatState combatState = combatService.getCombatState(playerId);
            response.put("success", true);
            response.put("message", "Estado do combate recuperado com sucesso");
            response.put("combatState", combatState);
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao recuperar estado do combate: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }
}