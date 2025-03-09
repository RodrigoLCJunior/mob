/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Classe Combate para usar no multiplas classes
 ** Obs...:
 */

package com.example.jogo.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Combate {

    private Avatar avatar;
    private List<Inimigo> inimigos;
    private int inimigoAtualIndex;

    public Combate(Avatar avatar, List<Inimigo> inimigos){
        this.avatar = avatar;
        this.inimigos = inimigos;
        this.inimigoAtualIndex = 0;
    }

    public boolean avatarAtacarInimigo() {
        if (inimigoAtualIndex < inimigos.size()) { // Se tiver inimigo na WAVE
            Inimigo inimigoAtual = inimigos.get(inimigoAtualIndex);
            int danoDoAvatar = avatar.getDanoBase();
            inimigoAtual.setHp(inimigoAtual.getHp() - danoDoAvatar);

            if (inimigoAtual.getHp() <= 0) { // Se o inimigo morreu
                System.out.println("Inimigo Derrotado");
                inimigoAtualIndex++;
                return true;
            } else {
                return false;
            }
        }
        return false;
    }

    public boolean isCombateFininalizado(){
        return inimigoAtualIndex >= inimigos.size();
    }

    public MoedaTemporaria droparMoeadas(){
        MoedaTemporaria moedas = new MoedaTemporaria();
        for (Inimigo inimigo : inimigos){
            if (inimigo.getHp() <= 0){
                int drop = inimigo.getRecompensa();
                moedas.setQuantidade(drop);
            }
        }
        return moedas;
    }

    public Avatar getAvatar() {
        return avatar;
    }

    public List<Inimigo> getInimigos() {
        return inimigos;
    }

    public Inimigo getInimigoAtual() {
        if (inimigoAtualIndex < inimigos.size()) {
            return inimigos.get(inimigoAtualIndex);
        }
        return null; // Não há mais inimigos
    }
}
