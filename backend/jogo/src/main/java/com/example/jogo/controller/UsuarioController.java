package com.example.jogo.controller;

import com.example.jogo.model.Usuarios;
import com.example.jogo.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping
    public List<Usuarios> listarUsuarios() {
        return usuarioService.listarUsuarios();
    }

    @GetMapping("/{id}")
    private Usuarios acharPorId(@PathVariable UUID id){
        return usuarioService.buscarUsuarioPorId(id);
    }

    @GetMapping("/{email}")
    private Usuarios buscarUsuarioPorEmail(@PathVariable String email) {
        return usuarioService.buscarUsuarioPorEmail(email);
    }

    @GetMapping("/{id}/experiencia-para-proximo-nivel")
    private void experienciaParaProximoNivel(Usuarios usuario) {
        usuarioService.experienciaParaProximoNivel(usuario);
    }

    @PostMapping("/{id}/experiencia")
    private Usuarios adicionarExperiencia(@PathVariable UUID id, @RequestParam int experiencia) {
        return usuarioService.adicionarExperiencia(id, experiencia);
    }

    @PostMapping
    private Usuarios salvarUsuariocriarUsuario(@RequestParam String nome, @RequestParam String email, @RequestParam String senha) {
        return usuarioService.criarUsuario(nome, email, senha);
    }
}
