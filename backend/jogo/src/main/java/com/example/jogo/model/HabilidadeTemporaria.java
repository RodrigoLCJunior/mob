/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "habilidade_temporaria")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class HabilidadeTemporaria {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private int custoMoedasTemporarias;

    @Column(nullable = false)
    private int nivel;

    @Column(nullable = false)
    private int vinculoHabilidade; // Novo campo para vincular habilidades de diferentes níveis

    @Column(nullable = false)
    private String descricao;

    @OneToMany(mappedBy = "habilidadeTemporaria", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AvatarHabilidadeTemporaria> avatarHabilidadeTemporarias;

    public HabilidadeTemporaria(){}

    public HabilidadeTemporaria(String nome, int custoMoedasTemporarias, int nivel, int vinculoHabilidade, String descricao){
        this.nome = nome;
        this.custoMoedasTemporarias = custoMoedasTemporarias;
        this.nivel = nivel;
        this.vinculoHabilidade = vinculoHabilidade;
        this.descricao = descricao;
    }

    // Metodo abstrato por cada habilidade especifica
    public abstract void aplicarEfeito(Object alvo);

    // Metodo para calcular o custo das habilidades
    public int calcularCusto(int desempenho) {
        return this.custoMoedasTemporarias + (this.nivel * desempenho);
    }

    public int getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public int getCustoMoedasTemporarias() {
        return custoMoedasTemporarias;
    }

    public int getNivel() {
        return nivel;
    }

    public List<AvatarHabilidadeTemporaria> getAvatarHabilidadeTemporarias() {
        return avatarHabilidadeTemporarias;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setCustoMoedasTemporarias(int custoMoedasTemporarias) {
        this.custoMoedasTemporarias = custoMoedasTemporarias;
    }

    public void setNivel(int nivel) {
        this.nivel = nivel;
    }

    public void setAvatarHabilidadeTemporarias(List<AvatarHabilidadeTemporaria> avatarHabilidadeTemporarias) {
        this.avatarHabilidadeTemporarias = avatarHabilidadeTemporarias;
    }

    public int getVinculoHabilidade() {
        return vinculoHabilidade;
    }

    public void setVinculoHabilidade(int vinculoHabilidade) {
        this.vinculoHabilidade = vinculoHabilidade;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }
}
