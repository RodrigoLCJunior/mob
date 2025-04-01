/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Dungeon para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "dungeon")
public class Dungeon {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private int numeroWaves;

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @Column(nullable = false)
    private boolean concluida;

    @Column(nullable = false)
    private boolean bloqueada;

    // Construtores, getters e setters
    public Dungeon() {
    }

    public Dungeon(String nome, int numeroWaves, boolean concluida, boolean bloqueada) {
        this.nome = nome;
        this.numeroWaves = numeroWaves;
        this.concluida = false;
        if (id == 1){
            this.bloqueada = false;
        } else {
            this.bloqueada = true;
        }

    }

    public int getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getNumeroWaves() {
        return numeroWaves;
    }

    public void setNumeroWaves(int numeroWaves) {
        this.numeroWaves = numeroWaves;
    }

    public boolean isConcluida() {
        return concluida;
    }

    public void setConcluida(boolean concluida) {
        this.concluida = concluida;
    }

    public boolean isBloqueada() {
        return bloqueada;
    }

    public void setBloqueada(boolean desbloqueada) {
        this.bloqueada = desbloqueada;
    }
}
