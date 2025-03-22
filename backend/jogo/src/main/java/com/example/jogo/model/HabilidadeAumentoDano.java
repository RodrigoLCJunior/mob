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
public class HabilidadeAumentoDano extends HabilidadeTemporaria{

    @Column(nullable = false)
    private int aumentoDano;

    @Column(nullable = false)
    private long intervalo;

    public HabilidadeAumentoDano() {}

    public HabilidadeAumentoDano(String nome, int custoMoedasTemporarias, int nivel, int aumentoDano, long intervalo, int vinculoHabilidade, String descricao) {
        super(nome, custoMoedasTemporarias, nivel, vinculoHabilidade, descricao);
        this.aumentoDano = aumentoDano;
        this.intervalo = intervalo;
    }

    @Override
    public void aplicarEfeito(Object alvo) {
        if (alvo instanceof Avatar) {
            Avatar avatar = (Avatar) alvo;
            int aumento = aumentoDano * getNivel(); // Aumento de dano multiplicado pelo nível
            avatar.setDanoBase(avatar.getDanoBase() + aumento);
        }
    }


    // Getters e Setters
    public int getAumentoDano() {
        return aumentoDano;
    }

    public void setAumentoDano(int aumentoDano) {
        this.aumentoDano = aumentoDano;
    }

    public long getIntervalo() {
        return intervalo;
    }

    public void setIntervalo(long intervalo) {
        this.intervalo = intervalo;
    }



}
