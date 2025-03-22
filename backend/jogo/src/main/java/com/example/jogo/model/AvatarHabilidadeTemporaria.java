/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "avatar_habilidade_temporaria")
public class AvatarHabilidadeTemporaria {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @ManyToOne
    @JoinColumn(name = "avatar_id", nullable = false)
    private Avatar avatar;

    @ManyToOne
    @JoinColumn(name = "habilidade_temporaria_id", nullable = false)
    private HabilidadeTemporaria habilidadeTemporaria;

    @Column(nullable = false)
    private int nivel;

    public AvatarHabilidadeTemporaria(){}

    public AvatarHabilidadeTemporaria(Avatar avatar, HabilidadeTemporaria habilidadeTemporaria, int nivel){
        this.avatar = avatar;
        this.habilidadeTemporaria = habilidadeTemporaria;
        this.nivel = nivel;
    }

    public int getId() {
        return id;
    }

    public Avatar getAvatar() {
        return avatar;
    }

    public HabilidadeTemporaria getHabilidadeTemporaria() {
        return habilidadeTemporaria;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public void setHabilidadeTemporaria(HabilidadeTemporaria habilidadeTemporaria) {
        this.habilidadeTemporaria = habilidadeTemporaria;
    }

    public int getNivel() {
        return nivel;
    }

    public void setNivel(int nivel) {
        this.nivel = nivel;
    }
}
