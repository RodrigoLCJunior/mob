/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 15/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Adaptar o maximo a dungeon para o Usuario
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Combate;
import com.example.jogo.model.Inimigo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CombateService {

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private InimigoService inimigoService;

    /* Rodrigo Luiz - 19/03/2025 - mob_018 */
    @Autowired
    private ProgressaoService progressaoService;

    public Combate iniciarCombate(Avatar avatar, Inimigo inimigo){
        return new Combate(avatar, inimigo);
    }

    public void avatarAtacar(Combate combate){
        Avatar avatar = combate.getAvatar();
        Inimigo inimigo = combate.getInimigo();

        inimigo.setHp(inimigo.getHp() - avatar.getDanoBase());

        if (inimigo.getHp() <= 0){
            combate.setCombateEmAndamento(false);
            combate.getMoedasTemporarias().adicionarMoedas(inimigo.getRecompensa());

            /* Rodrigo Luiz - 19/03/2025 - mob_018 */
            progressaoService.adicionarMoedasTemporarias(avatar, inimigo.getRecompensa());
            progressaoService.adicionarInimigoDerrotado(avatar);
        }

        if (avatar.getHp() <= 0){
            finalizarCombateComDerrota(combate);
        }

        progressaoService.adicionarClique(avatar);  /* Rodrigo Luiz - 19/03/2025 - mob_018 */
        avatarService.modificarAvatar(avatar.getId(), avatar.getHp(), avatar.getDanoBase());
        inimigoService.salvarInimigo(inimigo);
    }

    public void inimigoAtacar(Combate combate) {
        Avatar avatar = combate.getAvatar();
        Inimigo inimigo = combate.getInimigo();

        avatar.setHp(avatar.getHp() - inimigo.getDanoBase());

        if (avatar.getHp() <= 0) {
            finalizarCombateComDerrota(combate);
        }

        avatarService.modificarAvatar(avatar.getId(), avatar.getHp(), avatar.getDanoBase());
        inimigoService.salvarInimigo(inimigo);
    }

    private void finalizarCombateComDerrota(Combate combate){
        combate.setCombateEmAndamento(false);
        combate.setJogadorPerdeu(true);
        combate.getMoedasTemporarias().removerMoedas(combate.getMoedasTemporarias().getQuantidade());
    }
}
