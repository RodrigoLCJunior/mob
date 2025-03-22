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
import com.example.jogo.model.HabilidadeAumentoDano;
import com.example.jogo.repository.AvatarHabilidadeTemporariaRepository;
import com.example.jogo.repository.HabilidadeAumentoDanoRepository;
import com.example.jogo.repository.HabilidadeDanoAutomaticoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class HabilidadeAumentoDanoService {

    @Autowired
    private HabilidadeAumentoDanoRepository habilidadeAumentoDanoRepository;

    @Autowired
    private AvatarHabilidadeTemporariaRepository avatarHabilidadeTemporariaRepository;

    public Optional<HabilidadeAumentoDano> buscarHabilidadePorId(int id) {
        return habilidadeAumentoDanoRepository.findById(id);
    }

    public void aplicarHabilidade(Avatar avatar, HabilidadeAumentoDano habilidade){
        habilidade.aplicarEfeito(avatar);
        avatarHabilidadeTemporariaRepository.save(new AvatarHabilidadeTemporaria(avatar, habilidade, habilidade.getNivel()));
    }

    public HabilidadeAumentoDano salvarHabilidade(HabilidadeAumentoDano habilidade){
        return habilidadeAumentoDanoRepository.save(habilidade);
    }

    public void deletarHabilidade(int id){
        habilidadeAumentoDanoRepository.deleteById(id);
    }

}
