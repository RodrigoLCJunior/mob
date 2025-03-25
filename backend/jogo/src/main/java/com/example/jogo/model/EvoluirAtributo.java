/*
 ** Task..: 26 - Habilidades Permanentes
 ** Data..: 24/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo:Classe para Evoluir Habilidades Permanentes
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "evoluir_atributo")
public class EvoluirAtributo {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "avatar_id", nullable = false)
    private Avatar avatar;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoAtributo tipoAtributo;

    @Column(nullable = false)
    private int valorAtual;

    @Column(nullable = false)
    private int valorEvoluido;

    @Column(nullable = false)
    private int custo;

    public EvoluirAtributo() {}

    public EvoluirAtributo(Avatar avatar, TipoAtributo tipoAtributo, int valorAtual, int valorEvoluido, int custo) {
        this.avatar = avatar;
        this.tipoAtributo = tipoAtributo;
        this.valorAtual = valorAtual;
        this.valorEvoluido = valorEvoluido;
        this.custo = custo;
    }

    // Getters e Setters
    public UUID getId() {
        return id;
    }

    public Avatar getAvatar() {
        return avatar;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public TipoAtributo getTipoAtributo() {
        return tipoAtributo;
    }

    public void setTipoAtributo(TipoAtributo tipoAtributo) {
        this.tipoAtributo = tipoAtributo;
    }

    public int getValorAtual() {
        return valorAtual;
    }

    public void setValorAtual(int valorAtual) {
        this.valorAtual = valorAtual;
    }

    public int getValorEvoluido() {
        return valorEvoluido;
    }

    public void setValorEvoluido(int valorEvoluido) {
        this.valorEvoluido = valorEvoluido;
    }

    public int getCusto() {
        return custo;
    }

    public void setCusto(int custo) {
        this.custo = custo;
    }

    // Enum
    public enum TipoAtributo {
        HP, DANO_BASE, TAXA_MOEDAS_TEMPORARIAS,TAXA_MOEDAS_PERMANENTES;
    }
}
