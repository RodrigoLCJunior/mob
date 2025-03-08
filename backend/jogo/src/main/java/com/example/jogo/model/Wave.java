/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Wave para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "waves")
public class Wave {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @Column(nullable = false)
    private int numero;

    @OneToMany(mappedBy = "wave", cascade = CascadeType.ALL)
    private List<WaveInimigos> waveInimigos;

    public Wave(){
    }

    public Wave(int numero, List<WaveInimigos> waveInimigos){
        this.numero = numero;
        this.waveInimigos = waveInimigos;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public void setInimigos(List<WaveInimigos> waveInimigos) {
        this.waveInimigos = waveInimigos;
    }

    public int getId() {
        return id;
    }

    public int getNumero() {
        return numero;
    }

    public List<WaveInimigos> getWaveInimigos() {
        return waveInimigos;
    }
}
