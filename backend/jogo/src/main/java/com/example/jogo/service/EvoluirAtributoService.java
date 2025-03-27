/*
 ** Task..: 26 - Habilidades Permanentes
 ** Data..: 24/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Service de Evoluir Habilidades Permanentes
 ** Obs...: Vai ser alterado ainda
 */

package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.EvoluirAtributo;
import com.example.jogo.model.TipoAtributo;
import com.example.jogo.repository.EvoluirAtributoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class EvoluirAtributoService {

    @Autowired
    private EvoluirAtributoRepository evoluirAtributoRepository;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private ProgressaoService progressaoService;

    public Avatar evoluirAtributo(UUID avatarId, TipoAtributo tipoAtributo, int quantidade) {
        Avatar avatar = avatarService.buscarAvatarPorId(avatarId);

        EvoluirAtributo evoluirAtributo = evoluirAtributoRepository
                .findByAvatarAndTipoAtributo(avatar, tipoAtributo)
                .orElse(new EvoluirAtributo());

        evoluirAtributo.setAvatar(avatar);

        if (tipoAtributo == TipoAtributo.HP) {
            int hpBonus = evoluirAtributo.getNivelAtual() * 10;
            avatar.setHp(avatar.getHp() + hpBonus + quantidade);
        } else if (tipoAtributo == TipoAtributo.DANO_BASE) {
            int danoBonus = evoluirAtributo.getNivelAtual() * 5;
            avatar.setDanoBase(avatar.getDanoBase() + danoBonus + quantidade);
        }

        evoluirAtributo.evoluir();

        evoluirAtributoRepository.save(evoluirAtributo);
        return avatar;
    }
}
