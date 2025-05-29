package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.CombatState;
import com.example.jogo.model.Inimigo;
import com.example.jogo.model.Cards;
import com.example.jogo.model.Turn;
import com.example.jogo.repository.InimigoRepository;
import com.example.jogo.repository.UsuarioRepository;
import com.example.jogo.model.Usuarios;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.Collections;

@Service
public class CombatService {

    @Autowired
    private InimigoService inimigoService;

    @Autowired
    private UsuarioService usuarioService;

    private final Map<UUID, CombatState> combatStates = new HashMap<>();
    private final Random random = new Random();

    public CombatState startCombat(UUID playerId) {
        // Validar se o jogador existe e possui avatar
        Usuarios usuario = usuarioService.buscarUsuarioPorId(playerId);
        if(usuario == null) {
            throw new IllegalArgumentException("Jogador não encontrado pelo ID: " + playerId);
        }

        Avatar avatar = usuario.getAvatar();
        if (avatar == null) {
            throw new IllegalStateException("Jogador não possui um avatar válido.");
        }

        // Buscar todos os inimigos e selecionar um aleatório
        List<Inimigo> allEnemies = new ArrayList<>(inimigoService.findAll());
        if (allEnemies.isEmpty()) {
            throw new RuntimeException("Nenhum inimigo encontrado");
        }
        Inimigo enemy = allEnemies.get(random.nextInt(allEnemies.size()));

        // Inicializa as mãos com 5 cartas aleatórias, sem modificar o baralho original
        List<Cards> playerHand = drawCards(avatar.getDeck(), 5);
        List<Cards> enemyHand = drawCards(enemy.getDeck(), 5);

        CombatState combatState = new CombatState(playerId, avatar, enemy, playerHand);
        combatState.setEnemyHand(enemyHand);
        combatState.setCurrentTurn(Turn.PLAYER);
        combatState.setFirstTurn(true);
        combatState.setCombatActive(true);
        combatState.setPlayerHandRestored(true); // Para animação inicial
        combatState.setEnemyDeckRestored(true); // Para animação inicial

        combatStates.put(playerId, combatState);

        return combatState;
    }

    private List<Cards> drawCards(List<Cards> deck, int quantity) {
        List<Cards> hand = new ArrayList<>();
        if (deck == null || deck.isEmpty()) {
            return hand;
        }

        // Criar uma lista de índices para selecionar cartas aleatoriamente
        List<Integer> indices = new ArrayList<>();
        for (int i = 0; i < deck.size(); i++) {
            indices.add(i);
        }
        Collections.shuffle(indices, random);

        // Selecionar até 'quantity' cartas do baralho, sem removê-las
        int cardsToDraw = Math.min(quantity, deck.size());
        for (int i = 0; i < cardsToDraw; i++) {
            hand.add(deck.get(indices.get(i)));
        }
        return hand;
    }

    public CombatState playCard(UUID playerId, Long cardId) {
        CombatState combatState = validateCombatState(playerId);

        if (!combatState.isCombatActive()) {
            throw new IllegalStateException("Combate já terminou.");
        }
        if (combatState.isPlayerLost()) {
            throw new IllegalStateException("Jogador já perdeu o combate.");
        }
        if (combatState.getCurrentTurn() != Turn.PLAYER) {
            throw new IllegalStateException("Não é o turno do jogador.");
        }

        Cards cardToPlay = combatState.getPlayerHand().stream()
                .filter(card -> card.getId().equals(cardId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Carta não encontrada na mão do jogador"));

        int newEnemyHp = combatState.getEnemyHp() - cardToPlay.getDamage();
        combatState.setEnemyHp(Math.max(newEnemyHp, 0));

        // Remover a carta da mão temporária (playerHand), não do baralho original
        combatState.getPlayerHand().remove(cardToPlay);
        combatState.getUsedPlayerCards().add(cardToPlay);

        if (newEnemyHp <= 0) {
            combatState.setCombatActive(false);
            combatState.setPlayerWon(true);
        }

        combatState.setPlayerHandRestored(false); // Reseta a flag

        return combatState;
    }

    public CombatState endPlayerTurn(UUID playerId) {
        CombatState combatState = validateCombatState(playerId);

        if (!combatState.isCombatActive()) {
            throw new IllegalStateException("Combate já terminou.");
        }
        if (combatState.isPlayerLost()) {
            throw new IllegalStateException("Jogador já perdeu o combate.");
        }
        if (combatState.getCurrentTurn() != Turn.PLAYER) {
            throw new IllegalStateException("Não é o turno do jogador.");
        }

        combatState.setCurrentTurn(Turn.ENEMY);

        // Salva o estado do primeiro turno do inimigo
        boolean isFirstEnemyTurn = combatState.isFirstTurn();

        if (combatState.isFirstTurn()) {
            combatState.setFirstTurn(false);
        } else {
            // Comprar 3 cartas para o próximo turno do jogador, sem modificar o baralho original
            List<Cards> newPlayerCards = drawCards(combatState.getAvatar().getDeck(), 3);
            combatState.getPlayerHand().addAll(newPlayerCards);
            combatState.setPlayerHandRestored(true); // Define a flag para animação
        }

        handleEnemyTurn(combatState, isFirstEnemyTurn);

        return combatState;
    }

    private void handleEnemyTurn(CombatState combatState, boolean isFirstEnemyTurn) {
        if (!combatState.isCombatActive()) {
            return;
        }

        List<Cards> enemyHand = combatState.getEnemyHand();

        for (Cards card : enemyHand) {
            int newPlayerHp = combatState.getAvatarHp() - card.getDamage();
            combatState.setAvatarHp(Math.max(newPlayerHp, 0));
            combatState.getUsedEnemyCards().add(card);

            if (newPlayerHp <= 0) {
                combatState.setCombatActive(false);
                combatState.setPlayerLost(true);
                return;
            }
        }

        // Limpar a mão temporária do inimigo (enemyHand), não o baralho original
        enemyHand.clear();
        // Comprar 3 cartas para o inimigo, exceto no primeiro turno dele, sem modificar o baralho original
        if (!isFirstEnemyTurn) {
            combatState.setEnemyHand(drawCards(combatState.getEnemy().getDeck(), 3));
            combatState.setEnemyDeckRestored(true); // Define a flag para animação
        } else {
            combatState.setEnemyHand(new ArrayList<>()); // Limpa a mão sem comprar
            combatState.setEnemyDeckRestored(false); // Não anima no primeiro turno
        }
        combatState.setCurrentTurn(Turn.PLAYER);
    }

    public CombatState getCombatState(UUID playerId) {
        return validateCombatState(playerId);
    }

    private CombatState validateCombatState(UUID playerId) {
        Usuarios usuario = usuarioService.buscarUsuarioPorId(playerId);

        if (usuario == null) {
            throw new IllegalArgumentException("Jogador não encontrado pelo ID: " + playerId);
        }

        CombatState combatState = combatStates.get(playerId);
        if (combatState == null) {
            throw new IllegalStateException("Estado de combate não encontrado para o jogador: " + playerId);
        }

        return combatState;
    }
}