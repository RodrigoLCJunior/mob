package com.example.jogo.service;

import com.example.jogo.model.*;
import com.example.jogo.repository.InimigoRepository;
import com.example.jogo.repository.UsuarioRepository;
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
    private InimigoRepository inimigoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private WaveService waveService;

    @Autowired
    private DungeonService dungeonService;

    private final Map<UUID, CombatState> combatStates = new HashMap<>();
    private final Random random = new Random();

    public CombatState iniciarDungeon(UUID playerId, Long dungeonId) {
        // Buscar a dungeon pelo id
        Dungeon dungeon = dungeonService.buscarDungeonPorId(dungeonId);
        if (dungeon == null) {
            throw new RuntimeException("Dungeon não encontrada para o ID: " + dungeonId);
        }

        // Inicializar o estado do combate para o player
        CombatState combatState = new CombatState();
        if (combatState == null) {
            throw new RuntimeException("Erro ao criar o estado de combate para o jogador");
        }

        // Criar a wave usando o service, passando a quantidade de waves da dungeon
        Wave wave = waveService.iniciarWave(dungeon.getQtdWaves());
        if (wave == null) {
            throw new RuntimeException("Erro ao criar a wave para a dungeon");
        }
        combatState.setWave(wave);

        // Criar ou buscar o avatar do player
        Usuarios usuario = usuarioRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Jogador não encontrado"));

        Avatar avatar = usuario.getAvatar();
        if (avatar == null) {
            throw new IllegalStateException("Jogador não possui avatar");
        }
        combatState.setAvatar(avatar);

        // Escolher o primeiro inimigo da wave
        Inimigo inimigo = waveService.escolherInimigoNaoRepetido(wave);
        if (inimigo == null) {
            throw new RuntimeException("Erro ao selecionar o inimigo para a primeira wave");
        }
        combatState.setEnemy(inimigo);

        return combatState;
    }

    public CombatState startCombat(UUID playerId) {
        // Validar se o jogador existe e possui avatar
        Usuarios usuario = usuarioRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Jogador não encontrado pelo ID: " + playerId));

        Avatar avatar = usuario.getAvatar();
        if (avatar == null) {
            throw new IllegalStateException("Jogador não possui um avatar válido.");
        }

        // Recuperar o CombatState previamente criado na dungeon
        CombatState existingState = combatStates.get(playerId);
        if (existingState == null) {
            throw new IllegalStateException("Estado de combate não inicializado. Inicie uma dungeon antes do combate.");
        }

        Wave wave = existingState.getWave();
        if (wave == null) {
            throw new IllegalStateException("Wave não definida no estado de combate.");
        }

        // Selecionar inimigo não repetido para esta wave
        Inimigo enemy = waveService.escolherInimigoNaoRepetido(wave);
        if (enemy == null) {
            throw new RuntimeException("Erro ao selecionar inimigo para o combate");
        }

        // Inicializa as mãos com 5 cartas aleatórias, sem modificar o baralho original
        List<Cards> playerHand = drawCards(avatar.getDeck(), 5);
        List<Cards> enemyHand = drawCards(enemy.getDeck(), 5);

        // Criar o estado inicial do combate com dados do jogador, inimigo e wave
        CombatState combatState = new CombatState(playerId, avatar, enemy, playerHand);
        combatState.setEnemyHand(enemyHand);
        combatState.setWave(wave);
        combatState.setCurrentTurn(Turn.PLAYER);
        combatState.setFirstTurn(true);
        combatState.setCombatActive(true);
        combatState.setPlayerHandRestored(true); // Para animação inicial
        combatState.setEnemyDeckRestored(true);  // Para animação inicial

        // Armazenar o estado do combate para o jogador
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

        int newEnemyHp = combatState.getEnemyHp();
        switch (cardToPlay.getTipoEfeito()) {
            case DANO -> {
                newEnemyHp =  newEnemyHp - cardToPlay.getValor();
                combatState.setEnemyHp(Math.max(newEnemyHp, 0));
            }
            case CURA -> {
                int newPlayerHp = combatState.getAvatarHp() + cardToPlay.getValor();
                combatState.setAvatarHp(Math.min(newPlayerHp, combatState.getAvatar().getHp())); // hp maximo
            }
            case ESCUDO -> {
                // Em breve: poderíamos armazenar escudo temporário por turnos
                // Ex: combatState.setEscudoAtual(cardToPlay.getDamage());
            }
            case VENENO -> {
                // Em breve: marcar status "envenenado" por X turnos // serve tambem pra sangramente
            }
            case BUFF, DEBUFF -> {
                // Futuro: alteração de stats ou manipulação de cartas
            }
            default -> throw new IllegalStateException("Tipo de efeito desconhecido.");
        }


        // Remover a carta da mão temporária (playerHand), não do baralho original
        combatState.getPlayerHand().remove(cardToPlay);
        combatState.getUsedPlayerCards().add(cardToPlay);

        if (newEnemyHp <= 0) {
            combatState.setCombatActive(false);
            combatState.setPlayerWon(true);

            waveService.registrarDerrota(combatState.getWave(), combatState.getEnemy().getId());
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
            switch (card.getTipoEfeito()) {
                case DANO -> {
                    int newPlayerHp = combatState.getAvatarHp() - card.getValor();
                    combatState.setAvatarHp(Math.max(newPlayerHp, 0));
                }
                case CURA -> {
                    int newEnemyHp = combatState.getEnemyHp() + card.getValor();
                    combatState.setEnemyHp(Math.min(newEnemyHp, combatState.getEnemy().getHp())); // cura até o máximo original
                }
                case ESCUDO -> {
                    // Exemplo: não implementado ainda, mas você pode guardar o escudo em uma nova variável no CombatState
                }
                case VENENO -> {
                    // Exemplo: marcar o avatar como envenenado
                    // combatState.setAvatarPoisonTurns(3); // precisa criar o campo
                }
                default -> {
                    System.out.println("Efeito de carta não implementado: " + card.getTipoEfeito());
                }
            }

            combatState.getUsedEnemyCards().add(card);

            if (combatState.getAvatarHp() <= 0) {
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
        if (!usuarioRepository.existsById(playerId)) {
            throw new IllegalArgumentException("Jogador não encontrado pelo ID: " + playerId);
        }

        CombatState combatState = combatStates.get(playerId);
        if (combatState == null) {
            throw new IllegalStateException("Estado de combate não encontrado para o jogador: " + playerId);
        }

        return combatState;
    }

}