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
    private MoedaPermanente moedaPermanente; /* 07 - 12/03 - Filipe Augusto */
    //private List<SkillsAtivas> habilidadesAtivas;

    //Metodo de Criar o Avatar
    public Avatar(UUID id, int hp, int danoBase) {
        this.id = id;
        this.hp = hp;
        this.danoBase = danoBase;
        this.moedaPermanente = moedaPermanente;/* 07 - 12/03 - Filipe Augusto */
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

    /* 07 - 12/03 - Filipe Augusto */
    public MoedaPermanente getMoedaPermanente(){
        return moedaPermanente;
    }

    public void setDanoBase(int danoBase) {
        this.danoBase = danoBase;
    }

    public void setHp(int hp) {
        this.hp = hp;
    }

    /* 07 - 12/03 - Filipe Augusto */
    public void setMoedaPermanente(MoedaPermanente moedaPermanente) {
        this.moedaPermanente = moedaPermanente;
    }

}
