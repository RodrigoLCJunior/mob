package com.example.jogo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "cards")
public class Cards {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String nome;

    @Column(nullable = false)
    private String descricao;

    @Column(nullable = false)
    private int damage;

    @Column(nullable = false)
    private String imageCard;

    public Cards(){};

    public Cards(String nome, int damage) {
        if (nome == null || nome.trim().isEmpty()) {
            throw new IllegalArgumentException("Nome não pode ser nulo ou vazio");
        }
        this.nome = nome;
        this.damage = damage;
        this.descricao = ""; // Valor padrão para evitar null
        this.imageCard = ""; // Valor padrão para evitar null
    }

    public int getDamage() {
        return damage;
    }

    public void setDamage(int damage) {
        this.damage = damage;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Long getId() {
        return id;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getImageCard() {
        return imageCard;
    }

    public void setImageCard(String imageCard) {
        this.imageCard = imageCard;
    }
}
