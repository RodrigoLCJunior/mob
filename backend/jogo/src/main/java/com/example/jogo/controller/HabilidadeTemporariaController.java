package com.example.jogo.controller;


import com.example.jogo.model.Avatar;
import com.example.jogo.model.Combate;
import com.example.jogo.model.HabilidadeTemporaria;
import com.example.jogo.service.AvatarService;
import com.example.jogo.service.CombateService;
import com.example.jogo.service.DropHabilidadeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/habilidades")
public class HabilidadeTemporariaController {

    @Autowired
    private DropHabilidadeService dropHabilidadeService;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private CombateService combateService;

    // Endpoint para obter o drop de habilidades
    @GetMapping("/drop/{avatarId}")
    public ResponseEntity<Map<HabilidadeTemporaria, Integer>> obterDropHabilidades(@PathVariable UUID avatarId) {
        Avatar avatar = avatarService.getAvatar(avatarId);
        if (avatar == null) {
            return ResponseEntity.badRequest().build();
        }

        List<HabilidadeTemporaria> habilidades = dropHabilidadeService.gerarDropHabilidades(avatar);

        // Calcular o custo de cada habilidade e retornar junto com a habilidade
        Map<HabilidadeTemporaria, Integer> habilidadesComCusto = new HashMap<>();
        for (HabilidadeTemporaria habilidade : habilidades) {
            int custo = dropHabilidadeService.calcularCustoHabilidade(habilidade);
            habilidadesComCusto.put(habilidade, custo);
        }

        return ResponseEntity.ok(habilidadesComCusto);
    }

    // Endpoint para escolher uma habilidade do drop
    @PostMapping("/escolher/{avatarId}")
    public ResponseEntity<Void> escolherHabilidade(@PathVariable UUID avatarId, @RequestBody HabilidadeTemporaria habilidade) {
        Avatar avatar = avatarService.getAvatar(avatarId);
        if (avatar == null) {
            return ResponseEntity.badRequest().build();
        }

        Combate combate = combateService.getCombate(avatar);
        if (combate == null) {
            return ResponseEntity.badRequest().build();
        }

        // Verificar se o combate está em andamento e se o avatar tem moedas suficientes
        int custo = dropHabilidadeService.calcularCustoHabilidade(habilidade);
        if (!combate.isCombateEmAndamento() || combate.getMoedasTemporarias().getQuantidade() < custo) {
            return ResponseEntity.badRequest().build();
        }

        // Deduzir o custo das moedas temporárias do combate
        combate.getMoedasTemporarias().removerMoedas(custo);

        // Adicionar a habilidade ao avatar
        dropHabilidadeService.adicionarHabilidadeAoAvatar(avatar, habilidade);

        // Salvar as alterações no avatar
        avatarService.modificarAvatar(avatar.getId(), avatar.getHp(), avatar.getDanoBase());

        return ResponseEntity.ok().build();
    }
}
