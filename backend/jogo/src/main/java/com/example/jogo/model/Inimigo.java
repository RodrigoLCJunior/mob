/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;
import org.yaml.snakeyaml.events.Event;

@Entity
@Table(name = "inimigos")
public class Inimigo {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

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

    public Inimigo(int id, float hp, int danoBase, float timeToHit, int recompensa, int tipo) {
        this.id = id;
        this.hp = hp;
        this.danoBase = danoBase;
        this.timeToHit = timeToHit;
        this.recompensa = recompensa;
        this.tipo = tipo;
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
}
