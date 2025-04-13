/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Usuario
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.LoginResponse;
import com.example.jogo.model.Usuarios;
import com.example.jogo.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = {"http://localhost:8080", "http://localhost:9090", "http://10.0.2.2:9090", "*"}) // Permite todas as portas locais
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    // Buscar Todos Usuarios
    @GetMapping
    public ResponseEntity<List<Usuarios>> listarUsuarios() {
        List<Usuarios> usuariosList = usuarioService.listarUsuarios();
        if (usuariosList.isEmpty()){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(usuariosList);
    }

    // Buscar por ID
    @GetMapping("/{id}/id")
    private ResponseEntity<Usuarios> acharPorId(@PathVariable UUID id){
        Usuarios usuario = usuarioService.buscarUsuarioPorId(id);
        if(usuario == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(usuario);
    }

    /*
    // Buscar por E-mail
    @GetMapping("/{email}/email")
    private ResponseEntity<Usuarios> buscarUsuarioPorEmail(@PathVariable String email) {
        Usuarios usuario = usuarioService.buscarUsuarioPorEmail(email);
        if (usuario == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(usuario);
    }

    @GetMapping("/login")
    public ResponseEntity<Usuarios> buscarUsuarioPorEmail(@RequestParam("email") String email) {
        Usuarios usuario = usuarioService.buscarUsuarioPorEmail(email);
        if (usuario == null) {
            return ResponseEntity.noContent().build(); // 204 se não encontrar
        }
        return ResponseEntity.ok(usuario); // 200 com o usuário
    }*/

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody Usuarios loginRequest) {
        LoginResponse response = usuarioService.login(loginRequest);
        if (response.isSuccess()) {
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } else if ("email".equals(response.getError())) {
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404
        } else if ("senha".equals(response.getError())) {
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED); // 401
        } else {
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    // Endpoint para criar um novo usuário
    @PostMapping("/criar")
    public ResponseEntity<Map<String, Object>> criarUsuario(@RequestBody Usuarios usuario) {
        Map<String, Object> response = new HashMap<>();
        try {
            Usuarios novoUsuario = usuarioService.criarUsuario(usuario);
            response.put("success", true);
            response.put("message", "Usuário cadastrado com sucesso");
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao criar usuário: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @PutMapping("/{id}/alterar")
    public ResponseEntity<Usuarios> modificarUsuario(@PathVariable UUID id, @RequestBody Usuarios usuario){
        Usuarios usuarioAlterado = usuarioService.modificarUsuario(id, usuario);
        if (usuarioAlterado == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(usuarioAlterado);
    }

    @DeleteMapping("/{id}/deletar")
    public ResponseEntity<?> deletarUsuario(@PathVariable UUID id){
        usuarioService.deletarUsuario(id);
        return ResponseEntity.noContent().build();
    }
}
