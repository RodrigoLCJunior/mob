/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;

@Entity
public class HabilidadeDanoAutomatico extends HabilidadeTemporaria {

    @Column(nullable = false)
    private int danoPorSegundo;

    public HabilidadeDanoAutomatico() {}

    public HabilidadeDanoAutomatico(String nome, int custoMoedasTemporarias, int nivel, int danoPorSegundo, int vinculoHabilidade, String descricao) {
        super(nome, custoMoedasTemporarias, nivel, vinculoHabilidade, descricao);
        this.danoPorSegundo = danoPorSegundo;
    }

    @Override
    public void aplicarEfeito(Object alvo) {
        if (alvo instanceof Inimigo) {
            Inimigo inimigo = (Inimigo) alvo;
            int dano = danoPorSegundo * getNivel(); // Dano multiplicado pelo nível
            inimigo.setHp(inimigo.getHp() - dano);
        }
    }

    // Getters e Setters
    public int getDanoPorSegundo() {
        return danoPorSegundo;
    }

    public void setDanoPorSegundo(int danoPorSegundo) {
        this.danoPorSegundo = danoPorSegundo;
    }
}
