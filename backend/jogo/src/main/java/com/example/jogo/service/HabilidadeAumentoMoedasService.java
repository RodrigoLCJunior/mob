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
import com.example.jogo.model.HabilidadeAumentoMoedas;
import com.example.jogo.model.Inimigo;
import com.example.jogo.repository.AvatarHabilidadeTemporariaRepository;
import com.example.jogo.repository.HabilidadeAumentoMoedasRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class HabilidadeAumentoMoedasService {

    @Autowired
    private HabilidadeAumentoMoedasRepository habilidadeAumentoMoedasRepository;

    @Autowired
    private AvatarHabilidadeTemporariaRepository avatarHabilidadeTemporariaRepository;

    public Optional<HabilidadeAumentoMoedas> buscarHabilidadePorId(int id) {
        return habilidadeAumentoMoedasRepository.findById(id);
    }

    public void aplicarHabilidade(Avatar avatar, Inimigo inimigo, HabilidadeAumentoMoedas habilidade) {
        habilidade.aplicarEfeito(inimigo);
        avatarHabilidadeTemporariaRepository.save(new AvatarHabilidadeTemporaria(avatar, habilidade, habilidade.getNivel()));
    }

    public int calcularCustoHabilidade(HabilidadeAumentoMoedas habilidade, int desempenho) {
        return habilidade.calcularCusto(desempenho);
    }

    public HabilidadeAumentoMoedas salvarHabilidade(HabilidadeAumentoMoedas habilidade) {
        return habilidadeAumentoMoedasRepository.save(habilidade);
    }

    public void deletarHabilidade(int id) {
        habilidadeAumentoMoedasRepository.deleteById(id);
    }
}
