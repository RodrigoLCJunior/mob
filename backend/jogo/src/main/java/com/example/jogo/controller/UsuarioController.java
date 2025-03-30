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

    // Buscar Todos Usuarios
    @GetMapping
    public ResponseEntity<List<Usuarios>> listarUsuarios() {
        List<Usuarios> usuariosList = usuarioService.listarUsuarios();
        if (usuariosList.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(usuariosList);
    }

    // Buscar por ID
    @GetMapping("/{id}/id")
    private ResponseEntity<Usuarios> acharPorId(@PathVariable UUID id){
        Usuarios usuario = usuarioService.buscarUsuarioPorId(id);
        return ResponseEntity.ok(usuario);
    }

    // Buscar por E-mail
    @GetMapping("/{email}/email")
    private ResponseEntity<Usuarios> buscarUsuarioPorEmail(@PathVariable String email) {
        Usuarios usuario = usuarioService.buscarUsuarioPorEmail(email);
        if (usuario == null){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(usuario);
    }

    // Endpoint para criar um novo usuário
    @PostMapping("/criar")
    public ResponseEntity<Usuarios> criarUsuario(@RequestBody Usuarios usuario) {
        Usuarios novoUsuario = usuarioService.criarUsuario(usuario.getNome(), usuario.getEmail(), usuario.getSenha());
        return ResponseEntity.ok(novoUsuario);
    }

    @PutMapping("/{id}/alterar")
    public ResponseEntity<Usuarios> modificarUsuario(@PathVariable UUID id, @RequestBody Usuarios usuario){
        Usuarios usuarioAlterado = usuarioService.modificarUsuario(id, usuario);
        if (usuarioAlterado == null){
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(usuarioAlterado);
    }

    @DeleteMapping("/{id}/deletar")
    public ResponseEntity<?> deletarUsuario(@PathVariable UUID id){
        usuarioService.deletarUsuario(id);
        return ResponseEntity.noContent().build();
    }
}
