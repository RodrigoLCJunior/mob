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

    @Autowired
    private AvatarService avatarService;

    // Endpoint para evoluir um atributo do avatar
    @PostMapping("/{usuarioId}")
    public ResponseEntity<String> evoluirAtributo(@PathVariable UUID usuarioId,
                                                  @RequestParam String tipoAtributo,
                                                  @RequestParam int quantidade) {
        // Buscar usuário e avatar
        Usuarios usuario = usuarioService.buscarUsuarioPorId(usuarioId);
        if (usuario == null) {
            return ResponseEntity.badRequest().body("Usuário não encontrado.");
        }

        Avatar avatar = avatarService.buscarAvatarPorUsuario(usuario);
        if (avatar == null) {
            return ResponseEntity.badRequest().body("Avatar não encontrado.");
        }

        // Verificar se o usuário tem moedas permanentes suficientes
        if (usuario.getMoedaPermanente() < quantidade) {
            return ResponseEntity.badRequest().body("Moedas permanentes insuficientes.");
        }

        // Chamar o serviço para realizar a evolução
        EvoluirAtributo evoluirAtributo = evoluirAtributoService.evoluirAtributo(avatar, tipoAtributo, quantidade);

        // Atualizar moedas permanentes do usuário
        usuario.setMoedaPermanente(usuario.getMoedaPermanente() - quantidade);
        usuarioService.salvarUsuario(usuario);

        return ResponseEntity.ok("Atributo evoluído com sucesso!");
    }

}
