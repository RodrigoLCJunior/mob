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

import java.util.*;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }

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

    // Buscar por Email
    @GetMapping("/email")
    public ResponseEntity<Map<String, Object>> getUsuarioByEmail(@RequestParam String email) {
        Optional<Usuarios> usuarioOptional = usuarioService.buscarUsuarioPorEmail(email);
        Map<String, Object> response = new HashMap<>();

        if (usuarioOptional.isEmpty()) {
            response.put("success", false);
            response.put("error", "Usuário não encontrado para o email: " + email);
            return ResponseEntity.status(404).body(response);
        }

        response.put("success", true);
        response.put("user", usuarioOptional.get());
        return ResponseEntity.ok(response);
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

    // Endpoint para adicionar uma carta ao deck do avatar do usuário
    @PostMapping("/{id}/deck/add")
    public ResponseEntity<Map<String, Object>> adicionarCartaAoDeck(
            @PathVariable UUID id,
            @RequestParam("numeroCarta") Long numeroCarta) {
        Map<String, Object> response = new HashMap<>();
        try {
            Usuarios usuario = usuarioService.adicionarCartaAoDeckPorNumero(id, numeroCarta);
            response.put("success", true);
            response.put("message", "Carta adicionada ao deck com sucesso");
            response.put("usuario", usuario);
            return new ResponseEntity<>(response, HttpStatus.OK); // 200
        } catch (IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
        } catch (IllegalStateException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erro interno ao adicionar carta: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

    @DeleteMapping("/{id}/deletar")
    public ResponseEntity<?> deletarUsuario(@PathVariable UUID id){
        usuarioService.deletarUsuario(id);
        return ResponseEntity.noContent().build();
    }
}
