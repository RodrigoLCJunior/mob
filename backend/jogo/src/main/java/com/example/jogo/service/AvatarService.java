package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Progressao;
import com.example.jogo.repository.AvatarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class AvatarService {

    @Autowired
    private AvatarRepository avatarRepository;

    @Autowired
    private ProgressaoService progressaoService;

    public Avatar buscarAvatarPorId(UUID id) {
        return avatarRepository.findById(id).orElse(null);
    }

    public List<Avatar> listarAvatares() {
        return avatarRepository.findAll();
    }

    public Avatar criarAvatar(Avatar avatarNovo) {
        if (avatarNovo == null || avatarNovo.getHp() < 0) {
            throw new IllegalArgumentException("Dados inválidos para criar avatar");
        }

        Avatar avatar = new Avatar(avatarNovo.getHp());
        avatar = avatarRepository.save(avatar);

        try {
            Progressao progressao = new Progressao();
            progressao.setAvatarId(avatar.getId());
            progressao = progressaoService.salvarProgressao(progressao);
            avatar.setProgressao(progressao);
        } catch (Exception e) {
            throw new IllegalArgumentException("Erro ao criar progressão: " + e.getMessage(), e);
        }
        return avatarRepository.save(avatar);
    }

    @Transactional
    public Avatar aplicarDano(UUID id, int dano) {
        Avatar avatar = buscarAvatarPorId(id);
        if (avatar == null) {
            return null;
        }

        avatar.setHp(Math.max(0, avatar.getHp() - dano));
        return avatarRepository.save(avatar);
    }

    public boolean estaMorto(UUID id) {
        Avatar avatar = buscarAvatarPorId(id);
        return avatar == null || avatar.getHp() <= 0;
    }

    @Transactional
    public Avatar modificarAvatar(UUID id, int hp, int danoBase) {
        Avatar avatar = buscarAvatarPorId(id);
        if (avatar == null) {
            return null;
        }

        avatar.setHp(hp);
        return avatarRepository.save(avatar);
    }

    @Transactional
    public void deletarAvatarPorId(UUID avatarId) {
        avatarRepository.deleteById(avatarId);
    }
}
