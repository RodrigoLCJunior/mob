/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 15/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Adaptar o maximo a dungeon para o Usuario
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class CombateService {

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private AvatarService avatarService;

    @Autowired
    private InimigoService inimigoService;

    @Autowired
    private WaveService waveService;

    @Autowired
    private DungeonService dungeonService;

    @Autowired
    private ProgressaoService progressaoService;

    public Combate iniciarCombate(UUID userId, int dungeonId, int numeroDeInimigosPorWave) {
        Dungeon dungeon = dungeonService.getDungeon(dungeonId);
        if (dungeon == null || dungeon.isBloqueada()) {
            throw new IllegalStateException("Dungeon não encontrada ou está bloqueada.");
        }

        Usuarios usuario = usuarioService.buscarUsuarioPorId(userId);

        Avatar avatar = usuario.getAvatar();
        if (avatar == null) {
            throw new IllegalStateException("Avatar não encontrado para o usuário.");
        }

        List<Wave> waves = waveService.gerarWaves(userId, dungeonId, dungeon.getNumeroWaves(), numeroDeInimigosPorWave);
        Inimigo inimigoInicial = waves.get(0).getInimigos().get(0);

        Combate combate = new Combate(avatar, inimigoInicial);
        // Salvar o estado inicial do combate em algum armazenamento persistente ou cache

        return combate;
    }

    public void avatarAtacar(Combate combate){
        Avatar avatar = combate.getAvatar();
        Inimigo inimigo = combate.getInimigo();

        inimigo.setHp(inimigo.getHp() - avatar.getDanoBase());

        if (inimigo.getHp() <= 0){
            combate.setCombateEmAndamento(false);
            combate.getMoedasTemporarias().adicionarMoedas(inimigo.getRecompensa());

            progressaoService.adicionarMoedasTemporarias(avatar, inimigo.getRecompensa());
            progressaoService.adicionarInimigoDerrotado(avatar);
        }

        if (avatar.getHp() <= 0){
            finalizarCombateComDerrota(combate);
        }

        progressaoService.adicionarClique(avatar);
        avatarService.modificarAvatar(avatar.getId(), avatar.getHp(), avatar.getDanoBase());
        inimigoService.salvarInimigo(inimigo);
    }

    public void inimigoAtacar(Combate combate) {
        Avatar avatar = combate.getAvatar();
        Inimigo inimigo = combate.getInimigo();

        avatar.setHp(avatar.getHp() - inimigo.getDanoBase());

        if (avatar.getHp() <= 0) {
            finalizarCombateComDerrota(combate);
        }

        avatarService.modificarAvatar(avatar.getId(), avatar.getHp(), avatar.getDanoBase());
        inimigoService.salvarInimigo(inimigo);
    }

    private void finalizarCombateComDerrota(Combate combate){
        combate.setCombateEmAndamento(false);
        combate.setJogadorPerdeu(true);
        combate.getMoedasTemporarias().removerMoedas(combate.getMoedasTemporarias().getQuantidade());
    }
}