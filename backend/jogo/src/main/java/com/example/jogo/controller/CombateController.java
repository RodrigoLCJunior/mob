/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 18/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe combate
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Combate;
import com.example.jogo.model.Inimigo;
import com.example.jogo.service.AvatarService;
import com.example.jogo.service.CombateService;
import com.example.jogo.service.InimigoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/combate")
public class CombateController {

    @Autowired
    private CombateService combateService;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private InimigoService inimigoService;

    @PostMapping("/iniciar")
    public ResponseEntity<Combate> iniciarCombate(@RequestBody Map<String, Object> payload) {
        UUID userId = UUID.fromString((String) payload.get("userId"));
        int dungeonId = (int) payload.get("dungeonId");
        int numeroDeInimigosPorWave = (int) payload.get("numeroDeInimigosPorWave");

        Combate combate = combateService.iniciarCombate(userId, dungeonId, numeroDeInimigosPorWave);
        if (combate == null){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(combate);
    }

    @PostMapping("/avatar-atacar")
    public ResponseEntity<?> avatarAtacar(@RequestBody Combate combate){
        combateService.avatarAtacar(combate);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/inimigo-atacar")
    public ResponseEntity<?> inimigoAtacar(@RequestBody Combate combate){
        combateService.inimigoAtacar(combate);
        return ResponseEntity.noContent().build();
    }
}
