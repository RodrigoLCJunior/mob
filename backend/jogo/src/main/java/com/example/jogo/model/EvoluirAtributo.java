/*
 ** Task..: 26 - Habilidades Permanentes
 ** Data..: 24/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Classe para Evoluir Habilidades Permanentes
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
    private int custo;

    @Column(nullable = false)
    private int nivelAtual;

    @Column(nullable = false)
    private int nivelMaximo;

    public EvoluirAtributo() {}

    public EvoluirAtributo(Avatar avatar, TipoAtributo tipoAtributo, int custo, int nivelAtual, int nivelMaximo) {
        this.avatar = avatar;
        this.tipoAtributo = tipoAtributo;
        this.custo = custo;
        this.nivelAtual = nivelAtual;
        this.nivelMaximo = nivelMaximo;
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

    public int getCusto() {
        return custo;
    }

    public void setCusto(int custo) {
        this.custo = custo;
    }

    public int getNivelAtual() {
        return nivelAtual;
    }

    public void setNivelAtual(int nivelAtual) {
        this.nivelAtual = nivelAtual;
    }

    public int getNivelMaximo() {
        return nivelMaximo;
    }

    public void setNivelMaximo(int nivelMaximo) {
        this.nivelMaximo = nivelMaximo;
    }

    public boolean podeEvoluir() {
        return nivelAtual < nivelMaximo;
    }

    public void evoluir() {
        if (podeEvoluir()) {
            nivelAtual++;
            custo += custo * 0.2; // Aumento de 20% no custo por nível
        }
    }

    // Enum
    public enum TipoAtributo {
        HP, DANO_BASE, TAXA_MOEDAS_TEMPORARIAS, TAXA_MOEDAS_PERMANENTES;
    }
}
