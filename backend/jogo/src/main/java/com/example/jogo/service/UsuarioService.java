/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Usuario
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.model.Progressao;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.AvatarRepository;
import com.example.jogo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.UUID;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private MoedaPermanenteService moedaPermanenteService;

    public Usuarios buscarUsuarioPorEmail(String email) {
        return usuarioRepository.findByEmail(email).orElse(null);
    }

    public Usuarios buscarUsuarioPorId(UUID id){
        return usuarioRepository.findById(id).get();
    }

    public List<Usuarios> listarUsuarios() {
        return usuarioRepository.findAll();
    }

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public Usuarios criarUsuario(String nome, String email, String senha) {
        Usuarios usuario = new Usuarios();
        usuario.setNome(nome);
        usuario.setEmail(email);
        usuario.setSenha(senha);

        // Criar e associar um avatar ao usuário
        Avatar avatar = new Avatar(5, 1); // Valores iniciais de HP e danoBase
        avatar = avatarService.criarAvatar(avatar);

        //Criar e associar uma MoedaPermanente
        MoedaPermanente moedaPermanente = moedaPermanenteService.criarMoedaPermanente();

        // Associar o avatar e moeda ao usuário
        usuario.setAvatar(avatar);
        usuario.setMoedaPermanente(moedaPermanente);

        // Salvar o usuário
        return usuarioRepository.save(usuario);
    }

    public Usuarios modificarUsuario(UUID id, Usuarios usuarios){
        Usuarios usuarioVelho = usuarioRepository.findById(id).get();

        if (usuarioVelho == null){
            return null;
        }

        usuarioVelho.setNome(usuarios.getNome());
        usuarioVelho.setEmail(usuarios.getEmail());
        usuarioVelho.setSenha(usuarios.getSenha());

        return usuarioRepository.save(usuarioVelho);
    }

    public Usuarios salvarUsuario(Usuarios usuario) {
        return usuarioRepository.save(usuario);
    }

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public void deletarUsuario(UUID id) {
        usuarioRepository.deleteById(id);
    }
}

