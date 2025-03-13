/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar service Avatar para usar no Combate
 ** Obs...: O Avatar não precisa de Controller ou Repository, ele vai ser usado em memória.
 */

package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.MoedaPermanente;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;

@Service
public class AvatarService {

    private Avatar avatar;  // Aqui o avatar seria gerenciado pelo serviço

    // Criar Avatar para usar no combate
    public void criarAvatar(UUID usuarioId, int hp, int danoBase) {
        this.avatar = new Avatar(usuarioId, /* Sempre UUID       do Usuario */
                hp,        /* Sempre HP         do Usuario */
                danoBase); /* Sempre DANO BASE  do Usuario */
    }

    public Avatar getAvatar() {
        return avatar;
    }

    // Recebe o dano
    public void aplicarDano(int dano) {
        if (avatar != null) {
            avatar.setHp(Math.max(0, avatar.getHp() - dano)); // Garante que fica até o 0, não ficando negativo
        } else {
            System.out.println("Não encontrou nenhum Avatar (AvatarService.java)");
        }
    }

    public boolean estaMorto() {
        return avatar == null || avatar.getHp() == 0;
    }

    /* 07 - 12/03 - Filipe Augusto */
    // Método para obter as moedas permanentes associadas ao avatar
    public MoedaPermanente getMoedasPermanentes(Avatar avatar) {
        return avatar.getMoedaPermanente();  // Isso é apenas um exemplo
    }
    // Método para atualizar o avatar
    public void atualizarAvatar(Avatar avatar) {
    }
    // Método para atualizar as moedas permanentes
    public void atualizarMoedasPermanentes(MoedaPermanente moedas) {

    }
    private Map<String, Integer> custoEvolucao; // Mapa para armazenar os custos
    // Inicializando o mapa com os custos de evolução para os atributos
    public AvatarService() {
        custoEvolucao = new HashMap<>();
        custoEvolucao.put("hp", 50);  // Exemplo: Evoluir HP custa 50 moedas
        custoEvolucao.put("dano", 30);  // Exemplo: Evoluir Dano Base custa 30 moedas
    }

    // Evolui um atributo do Avatar usando moedas permanentes
    public String evoluirAtributo(UUID avatarId, String atributo) {
        if (avatar == null || !avatar.getId().equals(avatarId)) {
            return "Avatar não encontrado!";
        }

        MoedaPermanente moedas = getMoedasPermanentes(avatar); // Obtém as moedas permanentes associadas ao avatar

        if (moedas == null) {
            return "Moedas não encontradas para este avatar!";
        }

        // Verifica o custo do atributo a ser evoluído
        Integer custo = custoEvolucao.get(atributo.toLowerCase());
        if (custo == null) {
            return "Atributo inválido!";
        }

        // Verifica se o avatar tem moedas suficientes
        if (moedas.removerMoedas(custo)) {
            // Evolui o atributo
            switch (atributo.toLowerCase()) {
                case "hp":
                    avatar.setHp(avatar.getHp() + 10);  // Aumenta o HP em 10
                    break;
                case "dano":
                    avatar.setDanoBase(avatar.getDanoBase() + 2);  // Aumenta o dano base em 2
                    break;
            }

            // Atualiza o avatar e as moedas permanentes
            atualizarAvatar(avatar);
            atualizarMoedasPermanentes(moedas);

            return atributo + " evoluído com sucesso!";
        } else {
            return "Moedas insuficientes!";
        }
    }


    public MoedaPermanente getMoedaPermanente(Avatar avatar2) {
        return null;
    }
}

