/*
 ** Task..: 20 - Criação do Drop de habilidades
 ** Data..: 23/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Metodos de geracao de habilidades
 ** Obs...:
 */


package com.example.jogo.service;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.AvatarHabilidadeTemporaria;
import com.example.jogo.model.HabilidadeTemporaria;
import com.example.jogo.repository.AvatarHabilidadeTemporariaRepository;
import com.example.jogo.repository.HabilidadeTemporariaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class DropHabilidadeService {

    @Autowired
    private HabilidadeTemporariaRepository habilidadeTemporariaRepository;

    @Autowired
    private AvatarHabilidadeTemporariaRepository avatarHabilidadeTemporariaRepository;

    private static final int MAX_HABILIDADES = 5;
    private static final int NIVEL_MAXIMO = 5;
    private static final double CHANCE_DROP_INIMIGO = 0.1; // 10% de chance de drop ao derrotar um inimigo
    private Random random = new Random();

    // Gerar a habilidade randomicamente
    public List<HabilidadeTemporaria> gerarDropHabilidades(Avatar avatar) {
        List<HabilidadeTemporaria> habilidadesDisponiveis = new ArrayList<>();

        // Buscar todas as habilidades temporárias existentes
        List<HabilidadeTemporaria> todasHabilidades = habilidadeTemporariaRepository.findAll();

        // Adicionar três habilidades verificando se o avatar já possui uma habilidade com o mesmo valor de vinculoHabilidade
        int habilidadesAdicionadas = 0;
        while (habilidadesAdicionadas < 3 && !todasHabilidades.isEmpty()) {
            HabilidadeTemporaria habilidade = todasHabilidades.get(random.nextInt(todasHabilidades.size()));
            HabilidadeTemporaria finalHabilidade = habilidade;
            Optional<AvatarHabilidadeTemporaria> habilidadeExistente = avatar.getAvatarHabilidades().stream()
                    .filter(ah -> ah.getHabilidadeTemporaria().getVinculoHabilidade() == finalHabilidade.getVinculoHabilidade())
                    .findFirst();

            if (habilidadeExistente.isPresent()) {
                int novoNivel = habilidadeExistente.get().getNivel() + 1;
                if (novoNivel <= NIVEL_MAXIMO) {
                    habilidade = habilidadeTemporariaRepository.findByVinculoHabilidadeAndNivel(habilidade.getVinculoHabilidade(), novoNivel)
                            .orElse(habilidade);
                } else {
                    // Se todas as habilidades do avatar forem de nível máximo, não adicionar mais habilidades
                    continue;
                }
            }

            habilidadesDisponiveis.add(habilidade);
            habilidadesAdicionadas++;
        }

        return habilidadesDisponiveis;
    }

    // Calcular o custo das Habilidades
    public int calcularCustoHabilidade(HabilidadeTemporaria habilidade) {
        // Exemplo de cálculo de custo baseado no nível da habilidade
        return habilidade.getNivel() * 100; // Cada nível custa 100 moedas
    }

    // Calcular a chance de aparecer o drop
    public boolean verificarChanceDrop() {
        return random.nextDouble() < CHANCE_DROP_INIMIGO;
    }

    // Metodo de adicionar habilidade no Avatar
    public void adicionarHabilidadeAoAvatar(Avatar avatar, HabilidadeTemporaria habilidade) {
        if (avatar.getAvatarHabilidades().size() >= MAX_HABILIDADES) {
            throw new IllegalStateException("O avatar já possui o máximo de habilidades permitidas. (DropHabilidadeService.java)");
        }

        HabilidadeTemporaria finalHabilidade = habilidade;
        Optional<AvatarHabilidadeTemporaria> habilidadeExistente = avatar.getAvatarHabilidades().stream()
                .filter(ah -> ah.getHabilidadeTemporaria().getVinculoHabilidade() == finalHabilidade.getVinculoHabilidade())
                .findFirst();

        if (habilidadeExistente.isPresent()) {
            AvatarHabilidadeTemporaria avatarHabilidadeTemporaria = habilidadeExistente.get();
            int nivelAtual = avatarHabilidadeTemporaria.getNivel();
            int novoNivel = habilidade.getNivel();
            if (novoNivel > nivelAtual) {
                // Remover a habilidade existente da lista do avatar
                avatar.getAvatarHabilidades().remove(avatarHabilidadeTemporaria);

                // Atualizar a habilidade existente com o novo nível
                habilidade = habilidadeTemporariaRepository.findByVinculoHabilidadeAndNivel(habilidade.getVinculoHabilidade(), novoNivel)
                        .orElseThrow(() -> new IllegalArgumentException("Habilidade não encontrada (DropHabilidadeService.java)"));

                // Adicionar a habilidade atualizada à lista do avatar
                avatar.getAvatarHabilidades().add(new AvatarHabilidadeTemporaria(avatar, habilidade, novoNivel));
            }
        } else {
            // Adicionar a nova habilidade à lista do avatar
            avatar.getAvatarHabilidades().add(new AvatarHabilidadeTemporaria(avatar, habilidade, habilidade.getNivel()));
        }

        // Não salvar as mudanças no repositório do avatar para evitar persistência imediata
    }
}
