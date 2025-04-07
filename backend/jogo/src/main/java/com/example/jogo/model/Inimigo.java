/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "inimigos")
public class Inimigo {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private float hp;

    @Column(nullable = false)
    private int danoBase;

    @Column(nullable = false)
    private float timeToHit;

    @Column(nullable = false)
    private int recompensa;

    @Column(nullable = false)
    private int tipo;

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    @Column(nullable = false)
    private int nivelDeLiberacao;

    public Inimigo(){}

    public Inimigo(int id, String nome, float hp, int danoBase, float timeToHit, int recompensa, int tipo, int nivelDeLiberacao) {
        this.id = id;
        this.nome = nome; /* Rodrigo Luiz - 30/03/2025 - mob_031 */
        this.hp = hp;
        this.danoBase = danoBase;
        this.timeToHit = timeToHit;
        this.recompensa = recompensa;
        this.tipo = tipo;
        this.nivelDeLiberacao = nivelDeLiberacao; /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    }

    public void setHp(float hp) {
        this.hp = hp;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public void setRecompensa(int recompensa) {
        this.recompensa = recompensa;
    }

    public void setTimeToHit(float timeToHit) {
        this.timeToHit = timeToHit;
    }

    public void setDanoBase(int danoBase) {
        this.danoBase = danoBase;
    }

    public int getTipo() {
        return tipo;
    }

    public int getRecompensa() {
        return recompensa;
    }

    public float getTimeToHit() {
        return timeToHit;
    }

    public int getDanoBase() {
        return danoBase;
    }

    public float getHp() {
        return hp;
    }

    public int getId() {
        return id;
    }

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getNivelDeLiberacao() {
        return nivelDeLiberacao;
    }

    public void setNivelDeLiberacao(int nivelDeLiberacao) {
        this.nivelDeLiberacao = nivelDeLiberacao;
    }
}
