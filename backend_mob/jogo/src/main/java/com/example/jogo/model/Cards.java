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
    private int valor; // Chamava damage, mas com adicao de novos tipos de carta, esse campo se torna mais versatil

    @Column(nullable = false)
    private int qtdTurnos;

    @Column(nullable = false)
    private String imageCard;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoEfeito tipoEfeito;

    public Cards(){};

    public Cards(String nome, int valor, int qtdTurnos, TipoEfeito tipoEfeito) {
        if (nome == null || nome.trim().isEmpty()) {
            throw new IllegalArgumentException("Nome não pode ser nulo ou vazio");
        }
        this.nome = nome;
        this.valor = valor;
        this.qtdTurnos = qtdTurnos;
        this.descricao = ""; // Valor padrão para evitar null
        this.imageCard = ""; // Valor padrão para evitar null
        this.tipoEfeito = tipoEfeito; // Valor padrão para evitar null
    }

    public int getQtdTurnos() { return qtdTurnos; }

    public void setQtdTurnos(int qtdTurnos) { this.qtdTurnos = qtdTurnos; }

    public int getValor() {
        return valor;
    }

    public void setValor(int valor) {
        this.valor = valor;
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

    public TipoEfeito getTipoEfeito() { return tipoEfeito; }

    public void setTipoEfeito(TipoEfeito tipoEfeito) { this.tipoEfeito = tipoEfeito; }
}
