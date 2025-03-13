/*
 ** Task..: 7 - Habilidades Permanentes do Jogador
 ** Data..: 12/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Classe de Moedas Permanentes
 ** Obs...:
 */

package com.example.jogo.model;

public class MoedaPermanente {
    private int quantidade;

    public MoedaPermanente() {
        this.quantidade = 0;
    }

    public MoedaPermanente(int quantidade) {
        this.quantidade = quantidade;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public void adicionarMoedas(int quantidade) {
        this.quantidade += quantidade;
    }

    public boolean removerMoedas(int quantidade) {
        this.quantidade -= quantidade;
        if (this.quantidade < 0) {
            this.quantidade = 0;
        }
        return false;
    }
}
