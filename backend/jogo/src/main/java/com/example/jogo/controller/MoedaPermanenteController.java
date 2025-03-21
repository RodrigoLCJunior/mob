/*
 ** Task..: 25 - Moedas Permanentes
 ** Data..: 20/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Classe de Moedas Permanentes
 ** Obs...:
 */

package com.example.jogo.controller;

import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.service.MoedaPermanenteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/moedas")
public class MoedaPermanenteController {

    @Autowired
    private MoedaPermanenteService moedaPermanenteService;

    @GetMapping("/{id}")
    public MoedaPermanente obterMoeda(@PathVariable Long id) {
        return moedaPermanenteService.buscarPorId(id);
    }

    @PostMapping("/{id}/adicionar")
    public void adicionarMoedas(@PathVariable Long id, @RequestParam int quantidade) {
        moedaPermanenteService.adicionarMoedas(id, quantidade);
    }

    @PutMapping("/{id}/remover")
    public void removerMoedas(@PathVariable Long id, @RequestParam int quantidade) {
        moedaPermanenteService.removerMoedas(id, quantidade);
    }
}
