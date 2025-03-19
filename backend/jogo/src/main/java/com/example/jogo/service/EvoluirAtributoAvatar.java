/*
 ** Task..: 7 - Habilidades Permanentes do Jogador
 ** Data..: 12/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Service para a Evolução de Atributos do Jogador/Avatar
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Service
public class EvoluirAtributoAvatar {
    @Autowired
    private AvatarService avatarService;

    public String evoluirAtributo(UUID avatarId, String atributo, int custo) {
        Avatar avatar = avatarService.getAvatar(avatarId);  // Obtendo o avatar diretamente do AvatarService

        if (avatar == null || !avatar.getId().equals(avatarId)) {
            return "Avatar não encontrado! (EvoluirHabilidadesPermanentes.java)";
        }

        MoedaPermanente moedas = avatarService.getMoedasPermanentes(avatar);

        if (moedas == null) {
            return "Moedas não encontradas para este avatar! (EvoluirHabilidadesPermanentes.java)";
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
                    return "Atributo inválido! (EvoluirHabilidadesPermanentes.java)";
            }

            return atributo + " evoluído com sucesso! (EvoluirHabilidadesPermanentes.java)";
        } else {
            return "Moedas insuficientes! (EvoluirHabilidadesPermanentes.java)";
        }
    }
}