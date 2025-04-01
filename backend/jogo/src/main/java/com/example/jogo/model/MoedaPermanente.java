package com.example.jogo.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import java.util.UUID;

@Entity
public class MoedaPermanente {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

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
