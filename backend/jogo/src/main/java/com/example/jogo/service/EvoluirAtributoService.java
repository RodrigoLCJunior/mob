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

import java.util.Optional;
import java.util.UUID;

@Service
public class EvoluirAtributoService {

    @Autowired
    private EvoluirAtributoRepository evoluirAtributoRepository;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private ProgressaoService progressaoService;

    public Avatar evoluirAtributo(UUID avatarId, UUID idAtributo, int quantidade) {
        Avatar avatar = avatarService.getAvatar(avatarId);

        Optional<EvoluirAtributo> atributoEncontrado = avatar.getEvoluirAtributos()
                .stream()
                .filter(atributo -> atributo.getId().equals(idAtributo))
                .findFirst();

        if (atributoEncontrado.isPresent()) {
            EvoluirAtributo evoluirAtributo = atributoEncontrado.get();

            if (evoluirAtributo.podeEvoluir()) {
                evoluirAtributo.setAvatar(avatar);

                TipoAtributo tipoAtributo = evoluirAtributo.getTipoAtributo();

                if (tipoAtributo == TipoAtributo.HP) {
                    int hpBonus = evoluirAtributo.getNivelAtual() * 10;
                    avatar.setHp(avatar.getHp() + hpBonus + quantidade);
                } else if (tipoAtributo == TipoAtributo.DANO_BASE) {
                    int danoBonus = evoluirAtributo.getNivelAtual() * 5;
                    avatar.setDanoBase(avatar.getDanoBase() + danoBonus + quantidade);
                }

                evoluirAtributo.evoluir();
                evoluirAtributoRepository.save(evoluirAtributo);
            }
        }
        return avatar;
    }
}
