/*
** Task..: 13 - Sistema Inicial do Combate
** Data..: 08/03/2024
** Autor.: Rodrigo Luiz
** Motivo: Criar classe Avatar para usar no Combate
** Obs...:
*/

package com.example.jogo.model;
import java.util.UUID;
import java.util.List;

public class Avatar {
    private UUID id;
    private int hp;
    private int danoBase;
    //private List<SkillsAtivas> habilidadesAtivas;

    //Metodo de Criar o Avatar
    public Avatar(UUID id, int hp, int danoBase) {
        this.id = id;
        this.hp = hp;
        this.danoBase = danoBase;
    }

    public int getDanoBase() {
        return danoBase;
    }

    public int getHp() {
        return hp;
    }

    public UUID getId() {
        return id;
    }

    public void setDanoBase(int danoBase) {
        this.danoBase = danoBase;
    }

    public void setHp(int hp) {
        this.hp = hp;
    }
}
