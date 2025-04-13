/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar service Avatar para usar no Combate
 ** Obs...:
 */

package com.example.jogo.service;
import com.example.jogo.model.Avatar;
import com.example.jogo.model.Progressao;
import com.example.jogo.repository.AvatarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class AvatarService {

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @Autowired
    private AvatarRepository avatarRepository;

    @Autowired
    private ProgressaoService progressaoService;

    public Avatar getAvatar(UUID id) {
        return avatarRepository.findById(id).orElse(null);
    }

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    public List<Avatar> todosAvatares(){
        return avatarRepository.findAll();
    }

    public Avatar criarAvatar(Avatar avatarNovo){
        Avatar avatar = new Avatar(avatarNovo.getHp(), avatarNovo.getDanoBase());
        avatar = avatarRepository.save(avatar);

        Progressao progressao = new Progressao();
        progressao.setAvatarId(avatar.getId());
        progressaoService.salvarProgressao(progressao);

        avatar.setProgressao(progressao);
        avatar = avatarRepository.save(avatar);
        return avatar;
    }

    // Aplicar dano ao avatar
    public void aplicarDano(UUID id, int dano) {
        Avatar avatar = getAvatar(id);
        if (avatar != null) {
            avatar.setHp(Math.max(0, avatar.getHp() - dano)); // Garante que HP não fique negativo
            avatarRepository.save(avatar);
        } else {
            System.out.println("Não encontrou nenhum Avatar com ID: " + id + " (AvatarService.java)");
        }
    }

    public boolean estaMorto(UUID id) {
        Avatar avatar = getAvatar(id);
        return avatar == null || avatar.getHp() == 0;
    }

    public Avatar modificarAvatar(UUID id, int hp, int danoBase) {
        Avatar avatar = getAvatar(id);
        if (avatar != null) {
            avatar.setHp(hp);
            avatar.setDanoBase(danoBase);
            avatarRepository.save(avatar);
        }
        return avatar;
    }

    public void deletarAvatarPorId(UUID avatarId){
        avatarRepository.deleteById(avatarId);
    }
}
