/*
 ** Task..: 18 - Criação e formulação da classe Progresso
 ** Data..: 18/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Progressão
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.model.Progressao;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.ProgressaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProgressaoService {

    @Autowired
    private ProgressaoRepository progressaoRepository;

    @Autowired
    private UsuarioService usuarioService;

    public Progressao buscarProgressaoPorAvatar(Avatar avatar){
        return progressaoRepository.findByAvatar(avatar).orElseGet(() -> new Progressao(avatar));
    }

    public Progressao salvarProgressao(Progressao progressao){
        return progressaoRepository.save(progressao);
    }

    /* Filipe Augusto - 25/03/2025 - mob_dev_07_AtributoAvatar */
    public void adicionarMoedasTemporarias(Avatar avatar, int quantidade){
        Progressao progressao = buscarProgressaoPorAvatar(avatar);
        progressao.setTotalMoedasTemporarias(progressao.getTotalMoedasTemporarias() + quantidade);
        salvarProgressao(progressao);
    }

    public void adicionarClique(Avatar avatar){
        Progressao progressao = buscarProgressaoPorAvatar(avatar);
        progressao.setTotalCliques(progressao.getTotalCliques() + 1);
        progressaoRepository.save(progressao);
    }

    public void adicionarInimigoDerrotado(Avatar avatar){
        Progressao progressao = buscarProgressaoPorAvatar(avatar);
        progressao.setTotalInimigosDerrotados(progressao.getTotalInimigosDerrotados() + 1);
        salvarProgressao(progressao);
    }

    /* Filipe Augusto - 25/03/2025 - mob_dev_07_AtributoAvatar */
    public void adicionarMoedasPermanentes(Avatar avatar, int quantidade) {
        Usuarios usuario = avatar.getUsuario();
        if (usuario != null) {
            MoedaPermanente moedaPermanente = usuario.getMoedaPermanente();
            moedaPermanente.adicionarMoedas(quantidade);

            usuarioService.salvarUsuario(usuario);
        }
    }
}