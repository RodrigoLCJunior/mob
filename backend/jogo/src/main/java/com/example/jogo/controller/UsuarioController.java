package com.example.jogo.controller;

import com.example.jogo.model.Usuarios;
import com.example.jogo.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping
    public List<Usuarios> listarUsuarios() {
        return usuarioService.listarUsuarios();
    }

    @PostMapping
    public Usuarios salvarUsuariocriarUsuario(@RequestParam String nome, @RequestParam String email, @RequestParam String senha) {
        return usuarioService.criarUsuario(nome, email, senha);
    }

    @GetMapping("/{email}")
    public Usuarios buscarUsuarioPorEmail(@PathVariable String email) {
        return usuarioService.buscarUsuarioPorEmail(email);
    }
}
