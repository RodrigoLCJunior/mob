/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.AvatarHabilidadeTemporaria;
import com.example.jogo.model.HabilidadeDanoAutomatico;
import com.example.jogo.model.Inimigo;
import com.example.jogo.repository.AvatarHabilidadeTemporariaRepository;
import com.example.jogo.repository.HabilidadeDanoAutomaticoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class HabilidadeDanoAutomaticoService {

    @Autowired
    private HabilidadeDanoAutomaticoRepository habilidadeDanoAutomaticoRepository;

    @Autowired
    private AvatarHabilidadeTemporariaRepository avatarHabilidadeTemporariaRepository;

    public Optional<HabilidadeDanoAutomatico> buscarHabilidadePorId(int id) {
        return habilidadeDanoAutomaticoRepository.findById(id);
    }

    public void aplicarHabilidade(Avatar avatar, Inimigo inimigo, HabilidadeDanoAutomatico habilidade) {
        habilidade.aplicarEfeito(inimigo);
        avatarHabilidadeTemporariaRepository.save(new AvatarHabilidadeTemporaria(avatar, habilidade, habilidade.getNivel()));
    }

    public int calcularCustoHabilidade(HabilidadeDanoAutomatico habilidade, int desempenho) {
        return habilidade.calcularCusto(desempenho);
    }

    public HabilidadeDanoAutomatico salvarHabilidade(HabilidadeDanoAutomatico habilidade) {
        return habilidadeDanoAutomaticoRepository.save(habilidade);
    }

    public void deletarHabilidade(int id) {
        habilidadeDanoAutomaticoRepository.deleteById(id);
    }

}
