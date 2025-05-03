package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Progressao;
import com.example.jogo.repository.ProgressaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class ProgressaoService {

    @Autowired
    private ProgressaoRepository progressaoRepository;

    public Progressao acharProgressaoPorId(UUID progressaoId){
        return progressaoRepository.findById(progressaoId).orElse(null);
    }

    public List<Progressao> acharTodasProgressoes(){
        return progressaoRepository.findAll();
    }

    public Progressao buscarProgressaoPorAvatar(Avatar avatar){
        return progressaoRepository.findByAvatarId(avatar.getId());
    }

    @Transactional
    public Progressao salvarProgressao(Progressao progressao) {
        if (progressao == null) {
            throw new IllegalArgumentException("Progressão não pode ser nula");
        }
        return progressaoRepository.save(progressao);
    }

    @Transactional
    public void adicionarMoedasTemporarias(Avatar avatar, int quantidade) {
        if (quantidade < 0) {
            throw new IllegalArgumentException("Quantidade não pode ser negativa");
        }
        Progressao progressao = buscarProgressaoPorAvatar(avatar);
        if (progressao == null) {
            throw new IllegalStateException("Progressão não encontrada para o avatar");
        }
        progressao.setTotalMoedasTemporarias(progressao.getTotalMoedasTemporarias() + quantidade);
        salvarProgressao(progressao);
    }

    @Transactional
    public void adicionarClique(Avatar avatar) {
        Progressao progressao = buscarProgressaoPorAvatar(avatar);
        if (progressao == null) {
            throw new IllegalStateException("Progressão não encontrada para o avatar");
        }
        progressao.setTotalCliques(progressao.getTotalCliques() + 1);
        progressaoRepository.save(progressao);
    }

    @Transactional
    public void adicionarInimigoDerrotado(Avatar avatar) {
        Progressao progressao = buscarProgressaoPorAvatar(avatar);
        if (progressao == null) {
            throw new IllegalStateException("Progressão não encontrada para o avatar");
        }
        progressao.setTotalInimigosDerrotados(progressao.getTotalInimigosDerrotados() + 1);
        salvarProgressao(progressao);
    }

    @Transactional
    public void deletarProgressaoPorId(UUID progressaoId) {
        progressaoRepository.deleteById(progressaoId);
    }
}