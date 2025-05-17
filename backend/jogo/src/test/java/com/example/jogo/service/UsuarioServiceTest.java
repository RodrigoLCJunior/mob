package com.example.jogo.service;

import com.example.jogo.model.LoginResponse;
import com.example.jogo.model.Usuarios;
import com.example.jogo.repository.UsuarioRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class UsuarioServiceTest {

    @InjectMocks
    private UsuarioService usuarioService;

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private BCryptPasswordEncoder passwordEncoder;

    private Usuarios usuario;

    @BeforeEach
    void setUp() {
        usuario = new Usuarios("João", "joao@exemplo.com", "123456");
    }

    @Test
    void testLogin_Success() {
        when(usuarioRepository.findByEmail("joao@exemplo.com")).thenReturn(Optional.of(usuario));
        when(passwordEncoder.matches("123456", usuario.getSenha())).thenReturn(true);

        LoginResponse response = usuarioService.login(usuario);

        assertTrue(response.isSuccess());
        assertNull(response.getError());
    }

    @Test
    void testCreateUsuario() {
        when(usuarioRepository.findByEmail("joao@exemplo.com")).thenReturn(Optional.empty());

        Usuarios newUsuario = new Usuarios("João", "joao@exemplo.com", "123456");
        Usuarios createdUsuario = usuarioService.criarUsuario(newUsuario);

        assertNotNull(createdUsuario);
        assertEquals("João", createdUsuario.getNome());
        assertEquals("joao@exemplo.com", createdUsuario.getEmail());
    }
}
