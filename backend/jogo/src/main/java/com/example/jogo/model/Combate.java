/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 18/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe combate
 ** Obs...:
 */

package com.example.jogo.model;

public class Combate {

    private Avatar avatar;
    private Inimigo inimigo;
    private MoedaTemporaria moedasTemporarias;
    private boolean combateEmAndamento;
    private boolean jogadorPerdeu;

    public Combate(Avatar avatar, Inimigo inimigo) {
        this.avatar = avatar;
        this.inimigo = inimigo;
        this.moedasTemporarias = new MoedaTemporaria();
        this.combateEmAndamento = true;
        this.jogadorPerdeu = false;
    }

    // Getters e Setters

    public Avatar getAvatar() {
        return avatar;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public Inimigo getInimigo() {
        return inimigo;
    }

    public void setInimigo(Inimigo inimigo) {
        this.inimigo = inimigo;
    }

    public MoedaTemporaria getMoedasTemporarias() {
        return moedasTemporarias;
    }

    public boolean isCombateEmAndamento() {
        return combateEmAndamento;
    }

    public void setCombateEmAndamento(boolean combateEmAndamento) {
        this.combateEmAndamento = combateEmAndamento;
    }

    public boolean isJogadorPerdeu() {
        return jogadorPerdeu;
    }

    public void setJogadorPerdeu(boolean jogadorPerdeu) {
        this.jogadorPerdeu = jogadorPerdeu;
    }
}
