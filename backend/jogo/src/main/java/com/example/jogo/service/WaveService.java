/*
 ** Task..: 31 - Conexão Back e Front
 ** Data..: 30/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Wave
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Inimigo;
import com.example.jogo.model.Wave;
import com.example.jogo.repository.InimigoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class WaveService {

    @Autowired
    private InimigoRepository inimigoRepository;

    public List<Wave> gerarWaves(UUID userId, int dungeonId, int numeroDeWaves, int numeroDeInimigosPorWave) {
        List<Wave> waves = new ArrayList<>();
        List<Inimigo> todosInimigos = inimigoRepository.findAll();

        // Filtra os inimigos com base no nível de liberação
        List<Inimigo> inimigosFiltrados = new ArrayList<>();
        for (Inimigo inimigo : todosInimigos) {
            if (inimigo.getNivelDeLiberacao() <= dungeonId) {
                inimigosFiltrados.add(inimigo);
            }
        }

        Random random = new Random();

        // Gera as waves aleatoriamente
        for (int i = 1; i <= numeroDeWaves; i++) {
            List<Inimigo> inimigosDaWave = new ArrayList<>();
            for (int j = 0; j < numeroDeInimigosPorWave; j++) {
                Inimigo inimigoAleatorio = inimigosFiltrados.get(random.nextInt(inimigosFiltrados.size()));
                inimigosDaWave.add(inimigoAleatorio);
            }
            Wave wave = new Wave(i, inimigosDaWave);
            waves.add(wave);
        }

        return waves;
    }
}
