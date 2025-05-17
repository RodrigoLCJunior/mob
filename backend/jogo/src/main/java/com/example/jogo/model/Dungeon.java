/*
 ** Task..: 76 - Criação/Modificação das Classes para Wave
 ** Data..: 16/05/2025
 ** Autor.: Filipe Augusto
 ** Motivo: Criar Classes para Gerenciamento de Waves/Dungeons.
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "dungeons")
public class Dungeon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private int QtdWaves;

    @Column
    private String imagemDungeon; // Pode conter o caminho ou URL

    public Dungeon() {
    }

    public Dungeon(String nome, int QtdWaves, String imagemDungeon) {
        this.nome = nome;
        this.QtdWaves = QtdWaves;
        this.imagemDungeon = imagemDungeon;
    }

    public Long getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getQtdWaves() {
        return QtdWaves;
    }

    public void setQtdWaves(int qtdWaves) {
        QtdWaves = qtdWaves;
    }

    public String getImagemDungeon() {
        return imagemDungeon;
    }

    public void setImagemDungeon(String imagemDungeon) {
        this.imagemDungeon = imagemDungeon;
    }
}
