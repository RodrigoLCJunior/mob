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
public class HabilidadeAumentoMoedas extends HabilidadeTemporaria{

    @Column(nullable = false)
    private double porcentagemAumento;

    public HabilidadeAumentoMoedas(){}

    public HabilidadeAumentoMoedas(String nome, int custoMoedasTemporarias, int nivel, int porcentagemAumento, int vinculoHabilidade, String descricao) {
        super(nome, custoMoedasTemporarias, nivel, vinculoHabilidade, descricao);
        this.porcentagemAumento = porcentagemAumento;
    }

    @Override
    public void aplicarEfeito(Object alvo) {
        if (alvo instanceof Inimigo) {
            Inimigo inimigo = (Inimigo) alvo;
            int recompensaOriginal = inimigo.getRecompensa();
            int novaRecompensa = (int) Math.round(recompensaOriginal * (1 + (porcentagemAumento / 100.0))); // Aredondar o valor
            inimigo.setRecompensa(novaRecompensa);
        }
    }

    // Getters e Setters

    public double getPorcentagemAumento() {
        return porcentagemAumento;
    }

    public void setPorcentagemAumento(int porcentagemAumento) {
        this.porcentagemAumento = porcentagemAumento;
    }
}
