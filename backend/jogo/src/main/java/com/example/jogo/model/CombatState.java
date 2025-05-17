package com.example.jogo.model;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CombatState {
    private UUID playerId;
    private Avatar avatar;
    private Inimigo enemy;
    private Wave wave;
    private List<Cards> playerHand;
    private List<Cards> enemyHand;
    private List<Cards> usedPlayerCards;
    private List<Cards> usedEnemyCards;
    private Turn currentTurn;
    private boolean firstTurn;
    private boolean combatActive;
    private boolean playerWon;
    private boolean playerLost;
    private boolean playerHandRestored;
    private boolean enemyDeckRestored;

    // Campos para rastrear o HP durante o combate
    private int avatarHp;
    private int enemyHp;

    public CombatState() {
        this.usedPlayerCards = new ArrayList<>();
        this.usedEnemyCards = new ArrayList<>();
    }

    public CombatState(UUID playerId, Avatar avatar, Inimigo enemy, List<Cards> playerHand) {
        this.playerId = playerId;
        this.avatar = avatar;
        this.enemy = enemy;
        this.playerHand = playerHand;
        this.enemyHand = new ArrayList<>();
        this.usedPlayerCards = new ArrayList<>();
        this.usedEnemyCards = new ArrayList<>();
        this.avatarHp = avatar.getHp(); // Inicializa com o HP do Avatar
        this.enemyHp = enemy.getHp(); // Inicializa com o HP do Inimigo
    }

    // Getters e setters
    public UUID getPlayerId() { return playerId; }
    public void setPlayerId(UUID playerId) { this.playerId = playerId; }
    public Avatar getAvatar() { return avatar; }
    public void setAvatar(Avatar avatar) { this.avatar = avatar; }
    public Inimigo getEnemy() { return enemy; }
    public void setEnemy(Inimigo enemy) { this.enemy = enemy; }
    public Wave getWave() { return wave; }
    public void setWave(Wave wave) { this.wave = wave; }
    public List<Cards> getPlayerHand() { return playerHand; }
    public void setPlayerHand(List<Cards> playerHand) { this.playerHand = playerHand; }
    public List<Cards> getEnemyHand() { return enemyHand; }
    public void setEnemyHand(List<Cards> enemyHand) { this.enemyHand = enemyHand; }
    public List<Cards> getUsedPlayerCards() { return usedPlayerCards; }
    public void setUsedPlayerCards(List<Cards> usedPlayerCards) { this.usedPlayerCards = usedPlayerCards; }
    public List<Cards> getUsedEnemyCards() { return usedEnemyCards; }
    public void setUsedEnemyCards(List<Cards> usedEnemyCards) { this.usedEnemyCards = usedEnemyCards; }
    public Turn getCurrentTurn() { return currentTurn; }
    public void setCurrentTurn(Turn currentTurn) { this.currentTurn = currentTurn; }
    public boolean isFirstTurn() { return firstTurn; }
    public void setFirstTurn(boolean firstTurn) { this.firstTurn = firstTurn; }
    public boolean isCombatActive() { return combatActive; }
    public void setCombatActive(boolean combatActive) { this.combatActive = combatActive; }
    public boolean isPlayerWon() { return playerWon; }
    public void setPlayerWon(boolean playerWon) { this.playerWon = playerWon; }
    public boolean isPlayerLost() { return playerLost; }
    public void setPlayerLost(boolean playerLost) { this.playerLost = playerLost; }
    public boolean isPlayerHandRestored() { return playerHandRestored; }
    public void setPlayerHandRestored(boolean playerHandRestored) { this.playerHandRestored = playerHandRestored; }
    public boolean isEnemyDeckRestored() { return enemyDeckRestored; }
    public void setEnemyDeckRestored(boolean enemyDeckRestored) { this.enemyDeckRestored = enemyDeckRestored; }

    // Métodos para HP
    public int getAvatarHp() { return avatarHp; }
    public void setAvatarHp(int avatarHp) { this.avatarHp = avatarHp; }
    public int getEnemyHp() { return enemyHp; }
    public void setEnemyHp(int enemyHp) { this.enemyHp = enemyHp; }
}