/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar service Avatar para usar no Combate
 ** Obs...:
 */

package com.example.jogo.service;
import com.example.jogo.model.Avatar;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.AvatarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Service
public class AvatarService {

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @Autowired
    private AvatarRepository avatarRepository;

    public Avatar getAvatar(UUID id) {
        return avatarRepository.findById(id).orElse(null);
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

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    // Criar avatar para usuário
    public Avatar criarAvatar(Usuarios usuario) {
        Avatar avatar = new Avatar(5, 1, usuario); // Valores iniciais de HP e danoBase
        return avatarRepository.save(avatar);
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
}
