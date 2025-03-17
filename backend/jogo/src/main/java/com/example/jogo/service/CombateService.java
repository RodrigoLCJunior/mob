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
        }

        if (avatar.getHp() <= 0){
            finalizarCombateComDerrota(combate);
        }

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
