/*
 ** Task..: 7 - Habilidades Permanentes do Jogador
 ** Data..: 12/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Service para a Evolução de Habilidades
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Service
public class EvoluirHabilidadesPermanentes {

    @Autowired
    private AvatarService avatarService;

    public String evoluirAtributo(UUID avatarId, String atributo, int custo) {
        Avatar avatar = avatarService.getAvatar();  // Obtendo o avatar diretamente do AvatarService

        if (avatar == null || !avatar.getId().equals(avatarId)) {
            return "Avatar não encontrado!";
        }

        MoedaPermanente moedas = avatarService.getMoedaPermanente(avatar);

        if (moedas == null) {
            return "Moedas não encontradas para este avatar!";
        }

        if (moedas.removerMoedas(custo)) {
            switch (atributo.toLowerCase()) {
                case "hp":
                    avatar.setHp(avatar.getHp() + 10);  // Aumenta o HP em 10
                    break;
                case "dano":
                    avatar.setDanoBase(avatar.getDanoBase() + 2);  // Aumenta o dano base em 2
                    break;
                default:
                    return "Atributo inválido!";
            }

            avatarService.atualizarAvatar(avatar); // Método para atualizar o avatar no AvatarService
            avatarService.atualizarMoedasPermanentes(moedas); // Atualizar as moedas no AvatarService

            return atributo + " evoluído com sucesso!";
        } else {
            return "Moedas insuficientes!";
        }
    }
}
