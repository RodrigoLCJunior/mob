/*
 ** Task..: 26 - Habilidades Permanentes
 ** Data..: 24/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Controller de Evoluir Habilidades Permanentes
 ** Obs...: Vai ser alterado ainda
 */

package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.EvoluirAtributo;
import com.example.jogo.model.TipoAtributo;
import com.example.jogo.model.Usuarios;
import com.example.jogo.service.EvoluirAtributoService;
import com.example.jogo.service.AvatarService;
import com.example.jogo.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/evoluir")
public class EvoluirAtributoController {

    @Autowired
    private EvoluirAtributoService evoluirAtributoService;

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping("/{usuarioId}")
    public ResponseEntity<String> evoluirAtributo(@PathVariable UUID usuarioId,
                                                  @RequestParam String tipoAtributo,
                                                  @RequestParam int quantidade) {
        // Buscar usuário
        Usuarios usuario = usuarioService.buscarUsuarioPorId(usuarioId);
        if (usuario == null) {
            return ResponseEntity.badRequest().body("Usuário não encontrado.");
        }

        TipoAtributo tipo;
        try {
            tipo = TipoAtributo.valueOf(tipoAtributo.toUpperCase());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Tipo de atributo inválido.");
        }

        if (!usuario.getMoedaPermanente().removerMoedas(quantidade)) {
            return ResponseEntity.badRequest().body("Moedas permanentes insuficientes.");
        }

        Avatar avatar = evoluirAtributoService.evoluirAtributo(usuarioId, tipo, quantidade);

        if (avatar == null) {
            return ResponseEntity.badRequest().body("Avatar não encontrado ou não pode evoluir.");
        }

        usuarioService.salvarUsuario(usuario);

        return ResponseEntity.ok("Atributo evoluído com sucesso!");
    }
}