/*
 ** Task..: 76 - Criação/Modificação das Classes para Wave
 ** Data..: 16/05/2025
 ** Autor.: Filipe Augusto
 ** Motivo: Criar Classes para Gerenciamento de Waves/Dungeons.
 ** Obs...:
 */

package com.example.jogo.model;

import java.util.ArrayList;
import java.util.List;

public class Wave {
    private int waveAtual;
    private int waveFinal;
    private List<Long> inimigosDerrotados;
    private Long ultimoInimigoId; // <-- Novo campo

    public Wave(int waveAtual, int waveFinal) {
        this.waveAtual = waveAtual;
        this.waveFinal = waveFinal;
        this.inimigosDerrotados = new ArrayList<>();
        this.ultimoInimigoId = 0L;
    }

    public int getWaveAtual() {
        return waveAtual;
    }

    public void setWaveAtual(int waveAtual) {
        this.waveAtual = waveAtual;
    }

    public int getWaveFinal() {
        return waveFinal;
    }

    public void setWaveFinal(int waveFinal) {
        this.waveFinal = waveFinal;
    }

    public List<Long> getInimigosDerrotados() {
        return inimigosDerrotados;
    }

    public void setInimigosDerrotados(List<Long> inimigosDerrotados) {
        this.inimigosDerrotados = inimigosDerrotados;
    }

    public Long getUltimoInimigoId() {
        return ultimoInimigoId;
    }

    public void setUltimoInimigoId(Long ultimoInimigoId) {
        this.ultimoInimigoId = ultimoInimigoId;
    }
}