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

    @OneToMany(mappedBy = "dungeon", cascade = CascadeType.ALL)
    private List<Wave> waves;

    // Construtores, getters e setters

    public Dungeon() {
    }

    public Dungeon(String nome, List<Wave> waves) {
        this.nome = nome;
        this.waves = waves;
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

    public List<Wave> getWaves() {
        return waves;
    }

    public void setWaves(List<Wave> waves) {
        this.waves = waves;
    }

    public int getNumeroWaves() {
        return numeroWaves;
    }

    public void setNumeroWaves(int numeroWaves) {
        this.numeroWaves = numeroWaves;
    }
}
