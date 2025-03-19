/*
 ** Task..: 7 - Habilidades Permanentes do Jogador
 ** Data..: 19/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Classe de Moedas Permanentes
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Moeda_Permanente")
public class MoedaPermanente {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
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