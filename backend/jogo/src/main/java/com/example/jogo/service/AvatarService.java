/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar service Avatar para usar no Combate
 ** Obs...:
 */

package com.example.jogo.service;
import com.example.jogo.model.Avatar;
import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.AvatarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
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
        Avatar avatar = new Avatar(5, 1, usuario);
        avatar.setUsuario(usuario);
        avatar.setHp(5); // Definir valores iniciais para o avatar
        avatar.setDanoBase(1); // Definir valores iniciais para o avatar
        return avatar;
    }

    public Avatar criarAvatarController(Usuarios usuario) {
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

    /* Filipe Augusto - 19/03/2025 - mob_dev_07 */
    private Map<String, Integer> custoEvolucao; // Mapa para armazenar os custos
    // Inicializando o mapa com os custos de evolução para os atributos
    public AvatarService() {
        custoEvolucao = new HashMap<>();
        custoEvolucao.put("hp", 50);  // Exemplo: Evoluir HP custa 50 moedas
        custoEvolucao.put("dano", 30);  // Exemplo: Evoluir Dano Base custa 30 moedas
    }

    public MoedaPermanente getMoedasPermanentes(Avatar avatar) {
        return avatar.getMoedaPermanente();  // Isso é apenas um exemplo
    }

    public String evoluirAtributo(UUID avatarId, String atributo) {
        Avatar avatar = getAvatar(avatarId);
        if (avatar == null) {
            return "Avatar não encontrado! (AvatarService.java)";
        }

        MoedaPermanente moedas = avatar.getMoedaPermanente();
        if (moedas == null) {
            return "Moedas não encontradas para este avatar! (AvatarService.java)";
        }

        Integer custo = custoEvolucao.get(atributo.toLowerCase());
        if (custo == null) {
            return "Atributo inválido! (AvatarService.java)";
        }

        if (moedas.removerMoedas(custo)) {
            switch (atributo.toLowerCase()) {
                case "hp":
                    avatar.setHp(avatar.getHp() + 10);
                    break;
                case "dano":
                    avatar.setDanoBase(avatar.getDanoBase() + 2);
                    break;
            }
            avatarRepository.save(avatar);
            return atributo + " evoluído com sucesso! (AvatarService.java)";
        } else {
            return "Moedas insuficientes! (AvatarService.java)";
        }
    }
}
