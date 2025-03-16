package com.example.jogo.service;


import com.example.jogo.model.Avatar;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.AvatarRepository;
import com.example.jogo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.UUID;

@Service
public class UsuarioService {

    private int nivelMaximo = 20;

    @Autowired
    private UsuarioRepository usuarioRepository;

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @Autowired
    private AvatarRepository avatarRepository;

    @Autowired
    private AvatarService avatarService;

    public List<Usuarios> listarUsuarios() {
        return usuarioRepository.findAll();
    }

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public Usuarios criarUsuario(String nome, String email, String senha) {
        // Criar novo usuário
        Usuarios usuario = new Usuarios(nome, email, senha);
        usuario = usuarioRepository.save(usuario);

        // Criar avatar para o usuário
        Avatar avatar = avatarService.criarAvatar(usuario);
        avatar = avatarRepository.save(avatar); // Salvar o avatar no banco de dados
        usuario.setAvatar(avatar);
        usuario = usuarioRepository.save(usuario); // Salvar a associação do avatar com o usuário

        return usuario;
    }

    public Usuarios salvarUsuario(Usuarios usuario) {
        return usuarioRepository.save(usuario);
    }

    public Usuarios buscarUsuarioPorEmail(String email) {
        return usuarioRepository.findByEmail(email).orElse(null);
    }

    public Usuarios buscarUsuarioPorId(UUID id){
        return usuarioRepository.findById(id).get();
    }

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public void deletarUsuario(UUID id) {
        usuarioRepository.deleteById(id);
    }

    public Usuarios adicionarExperiencia(UUID usuarioId, int experiencia) {
        Usuarios usuario = buscarUsuarioPorId(usuarioId);
        if (usuario != null) {
            usuario.setExperiencia(usuario.getExperiencia() + experiencia);
            while (usuario.getExperiencia() >= experienciaParaProximoNivel(usuario) && usuario.getNivel() < nivelMaximo) {
                usuario.setExperiencia(usuario.getExperiencia() - experienciaParaProximoNivel(usuario));
                usuario.setNivel(usuario.getNivel() + 1);
            }
            usuarioRepository.save(usuario);
        }
        return usuario;
    }

    public int experienciaParaProximoNivel(Usuarios usuario) {
        // Fórmula simples: 100 * nível atual
        return usuario.getNivel() * 100;
    }
}

