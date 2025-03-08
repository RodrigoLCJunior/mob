/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Wave para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "wave_inimigo")
public class WaveInimigos {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @ManyToOne
    @JoinColumn(name = "wave_id", nullable = false)
    private Wave wave;

    @ManyToOne
    @JoinColumn(name = "inimigo_id", nullable = false)
    private Inimigo inimigo;

    public WaveInimigos(){

    }

    public WaveInimigos(Wave wave, Inimigo inimigo){
        this.wave = wave;
        this.inimigo = inimigo;
    }

    public void setInimigo(Inimigo inimigo) {
        this.inimigo = inimigo;
    }

    public void setWave(Wave wave) {
        this.wave = wave;
    }

    public int getId() {
        return id;
    }

    public Inimigo getInimigo() {
        return inimigo;
    }

    public Wave getWave() {
        return wave;
    }
}
