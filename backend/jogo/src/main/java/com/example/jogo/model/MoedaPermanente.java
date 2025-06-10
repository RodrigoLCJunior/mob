/*
 ** Task..: 26 - Criação da Classe HabilidadesPermanentes
 ** Data..: 29/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe para as habilidades
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
public class MoedaPermanente {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int quantidade;

    public MoedaPermanente() {
        this.quantidade = 0;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }
}
