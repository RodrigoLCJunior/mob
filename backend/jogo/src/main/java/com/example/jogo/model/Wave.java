/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Wave para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

import java.util.List;

public class Wave {

    private int numero;
    private List<Inimigo> inimigos;

    public Wave(int numero, List<Inimigo> inimigos) {
        this.numero = numero;
        this.inimigos = inimigos;
    }

    public int getNumero() {
        return numero;
    }

    public List<Inimigo> getInimigos() {
        return inimigos;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public void setInimigos(List<Inimigo> inimigos) {
        this.inimigos = inimigos;
    }
}
