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

@Service
public class EvoluirAtributoService {

    @Autowired
    private EvoluirAtributoRepository evoluirAtributoRepository;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private ProgressaoService progressaoService;

    public void evoluirAtributo(UUID avatarId, TipoAtributo tipoAtributo, int quantidade) {
        Avatar avatar = avatarService.buscarAvatarPorId(avatarId);

        EvoluirAtributo evoluirAtributo = evoluirAtributoRepository
                .findByAvatarAndTipoAtributo(avatar, tipoAtributo)
                .orElse(new EvoluirAtributo());

        evoluirAtributo.setAvatar(avatar);
        evoluirAtributo.setTipoAtributo(tipoAtributo);

        // Lógica para atualizar o atributo
        if (tipoAtributo == TipoAtributo.HP) {
            evoluirAtributo.setQuantidadeHP(evoluirAtributo.getQuantidadeHP() + quantidade);
        } else if (tipoAtributo == TipoAtributo.DANO_BASE) {
            evoluirAtributo.setQuantidadeDanoBase(evoluirAtributo.getQuantidadeDanoBase() + quantidade);
        }
        else if (tipoAtributo == TipoAtributo.MOEDAS_TEMPORARIAS) {
            progressaoService.adicionarMoedasTemporarias(avatar, quantidade);
        } else if (tipoAtributo == TipoAtributo.MOEDAS_PERMANENTES) {
            progressaoService.adicionarMoedasPermanentes(avatar, quantidade);
        }

        evoluirAtributoRepository.save(evoluirAtributo);
    }
}
