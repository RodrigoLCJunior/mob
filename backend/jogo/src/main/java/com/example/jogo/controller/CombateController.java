package com.example.jogo.controller;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.Combate;
import com.example.jogo.model.Inimigo;
import com.example.jogo.service.AvatarService;
import com.example.jogo.service.CombateService;
import com.example.jogo.service.InimigoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
    public Combate iniciarCombate(@RequestParam UUID avatarId, @RequestParam int inimigoId){
        Avatar avatar = avatarService.getAvatar(avatarId);
        Inimigo inimigo = inimigoService.findById(inimigoId).get();

        return combateService.iniciarCombate(avatar, inimigo);
    }

    @PostMapping("/avatar-atacar")
    public void avatarAtacar(@RequestBody Combate combate){
        combateService.avatarAtacar(combate);
    }

    @PostMapping("/inimigo-atacar")
    public void inimigoAtacar(@RequestBody Combate combate){
        combateService.inimigoAtacar(combate);
    }
}
