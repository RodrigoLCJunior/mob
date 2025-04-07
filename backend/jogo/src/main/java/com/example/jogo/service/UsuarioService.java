/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Usuario
 ** Obs...:
 */

package com.example.jogo.service;
import com.example.jogo.model.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.example.jogo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private MoedaPermanenteService moedaPermanenteService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    public LoginResponse login(Usuarios loginRequest) {
        Optional<Usuarios> usuarioOpt = usuarioRepository.findByEmail(loginRequest.getEmail());

        if (usuarioOpt.isEmpty()) {
            return new LoginResponse(false, "email", "Email não encontrado", null);
        }

        Usuarios usuario = usuarioOpt.get();

        if (passwordEncoder.matches(loginRequest.getSenha(), usuario.getSenha())) {
            return new LoginResponse(true, null, null, usuario);
        } else {
            return new LoginResponse(false, "senha", "Senha incorreta", null);
        }
    }

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
    public Usuarios criarUsuario(Usuarios usuarioRequest) throws IllegalArgumentException {
        // Validação de campos obrigatórios
        if (usuarioRequest.getNome() == null || usuarioRequest.getNome().trim().isEmpty() ||
                usuarioRequest.getEmail() == null || usuarioRequest.getEmail().trim().isEmpty() ||
                usuarioRequest.getSenha() == null || usuarioRequest.getSenha().trim().isEmpty()) {
            throw new IllegalArgumentException("Campos obrigatórios estão vazios");
        }

        // Verifica se o email já existe
        Optional<Usuarios> existingUser = usuarioRepository.findByEmail(usuarioRequest.getEmail());
        if (existingUser.isPresent()) {
            throw new IllegalArgumentException("Email já está em uso");
        }

        // Criptografa a senha
        String senhaCriptografada = passwordEncoder.encode(usuarioRequest.getSenha());
        Usuarios usuario = new Usuarios();
        usuario.setNome(usuarioRequest.getNome());
        usuario.setEmail(usuarioRequest.getEmail());
        usuario.setSenha(senhaCriptografada);

        // Cria avatar e moeda permanente
        Avatar avatar = new Avatar(5, 1);
        avatar = avatarService.criarAvatar(avatar);
        if (avatar == null) {
            throw new IllegalArgumentException("Falha ao criar avatar");
        }

        MoedaPermanente moedaPermanente = moedaPermanenteService.criarMoedaPermanente();
        if (moedaPermanente == null) {
            throw new IllegalArgumentException("Falha ao criar moeda permanente");
        }

        usuario.setAvatar(avatar);
        usuario.setMoedaPermanente(moedaPermanente);
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

