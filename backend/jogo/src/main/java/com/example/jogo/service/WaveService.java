/*
 ** Task..: 76 - Criação/Modificação das Classes para Wave
 ** Data..: 16/05/2025
 ** Autor.: Filipe Augusto
 ** Motivo: Criar Classes para Gerenciamento de Waves/Dungeons.
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Inimigo;
import com.example.jogo.model.Wave;
import com.example.jogo.repository.InimigoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
public class WaveService {
    private final Random random = new Random();

    @Autowired
    private InimigoRepository inimigoRepository;

    @Autowired
    private InimigoService inimigoService;

    public Wave iniciarWave(int waveFinal) {
        Wave wave = new Wave(1, waveFinal); // Começa na wave 1 e define o total com base na Dungeon
        if (wave == null) {
            throw new RuntimeException("Erro ao criar a wave");
        }
        return wave;
    }

    public void proximaWave(Wave wave) {
        wave.setWaveAtual(wave.getWaveAtual() + 1);
    }

    public boolean temProximaWave(Wave wave) {
        return wave.getWaveFinal() == 0 || wave.getWaveAtual() < wave.getWaveFinal();
    }

    public void registrarDerrota(Wave wave, Long inimigoId) {
        if (!wave.getInimigosDerrotados().contains(inimigoId)) {
            boolean added = wave.getInimigosDerrotados().add(inimigoId);
            if (!added) {
                throw new RuntimeException("Erro ao registrar inimigo derrotado: " + inimigoId);
            }
        }
    }

    public boolean foiDerrotado(Wave wave, Long inimigoId) {
        return wave.getInimigosDerrotados().contains(inimigoId);
    }

    public boolean terminou(Wave wave) {
        return wave.getWaveAtual() > wave.getWaveFinal();
    }

    public Inimigo escolherInimigoNaoRepetido(Wave wave) {
        List<Inimigo> allEnemies = inimigoService.findAll();

        Long ultimoId = wave.getUltimoInimigoId();

        List<Inimigo> candidatos = allEnemies.stream()
                .filter(e -> !e.getId().equals(ultimoId))
                .filter(e -> !foiDerrotado(wave, e.getId()))
                .collect(Collectors.toList());

        if (candidatos.isEmpty()) {
            throw new RuntimeException("Não há mais inimigos disponíveis para esta wave.");
        }

        Inimigo escolhido = candidatos.get(random.nextInt(candidatos.size()));

        wave.setUltimoInimigoId(escolhido.getId());

        return escolhido;
    }
}