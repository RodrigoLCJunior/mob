/*
** Task..: 13 - Sistema Inicial do Combate
** Data..: 08/03/2024
** Autor.: Rodrigo Luiz
** Motivo: Criar classe Avatar para usar no Combate
** Obs...:
*/

package com.example.jogo.model;
import jakarta.persistence.*;

import java.util.UUID;
import java.util.List;

/* Rodrigo Luiz - 15/03/2025 - mob_015 */
@Entity
@Table(name = "avatar")
public class Avatar {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false)
    private int hp;

    @Column(nullable = false)
    private int danoBase;

    //private List<SkillsAtivas> habilidadesAtivas;

    //Metodo de Criar o Avatar
    public Avatar(){}

    public Avatar(int hp, int danoBase) {
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
