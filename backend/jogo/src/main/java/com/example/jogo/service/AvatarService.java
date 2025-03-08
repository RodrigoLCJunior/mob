/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar service Avatar para usar no Combate
 ** Obs...: O Avatar não precisa de Controller ou Repository, ele vai ser usado em memória.
 */

package com.example.jogo.service;
import com.example.jogo.model.Avatar;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Service
public class AvatarService {
    private Avatar avatar;

    // Criar Avatar para usar no combate
    public void criarAvatar(UUID usuarioId, int hp, int danoBase){
        this.avatar = new Avatar(usuarioId, /* Sempre UUID       do Usuario */
                                 hp,        /* Sempre HP         do Usuario */
                                 danoBase); /* Sempre DANO BASE  do Usuario */
    }

    public Avatar getAvatar() {
        return avatar;
    }

    // Recebe o dano
    public void aplicarDano(int dano){
        if(avatar != null){
            avatar.setHp(Math.max(0, avatar.getHp() - dano)); // Garante que fiza até o 0, não ficando negativo
        } else {
            System.out.println("Não encontrou nenhum Avatar (AvatarService.java)");
        }
    }

    public boolean estaMorto(){
        return avatar != null || avatar.getHp() == 0;
    }
}
