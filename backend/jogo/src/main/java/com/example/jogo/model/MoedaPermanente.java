/*
 ** Task..: 25 - Moedas Permanentes
 ** Data..: 20/03/2024
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
        this.quantidade = Math.max(0, quantidade);
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = Math.max(0, quantidade);
    }

    public void adicionarMoedas(int quantidade) {
        if (quantidade > 0) {
            this.quantidade += quantidade;
        }
    }

    public boolean removerMoedas(int quantidade) {
        if (quantidade > 0 && this.quantidade >= quantidade) {
            this.quantidade -= quantidade;
            return true;
        }
        return false;
    }
}
