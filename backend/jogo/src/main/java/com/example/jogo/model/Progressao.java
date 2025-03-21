/*
 ** Task..: 18 - Criação e formulação da classe Progresso
 ** Data..: 18/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Progressão
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "progressao")
public class Progressao {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int totalMoedasTemporarias;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int totalCliques;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int totalInimigosDerrotados;

    @OneToOne
    @JoinColumn(name = "avatar_id", nullable = false)
    private Avatar avatar;

    /* Filipe Augusto - 20/03/2025 - mob_dev_26_MoedaPermanente */
    @OneToOne
    @JoinColumn(name = "moeda_permanente_id", nullable = false)
    private MoedaPermanente moedaPermanente;

    public Progressao(){}

    public Progressao(Avatar avatar) {
        this.avatar = avatar;
    }

    public UUID getId() {
        return id;
    }

    public Avatar getAvatar() {
        return avatar;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public int getTotalInimigosDerrotados() {
        return totalInimigosDerrotados;
    }

    public void setTotalInimigosDerrotados(int totalInimigosDerrotados) {
        this.totalInimigosDerrotados = totalInimigosDerrotados;
    }

    public int getTotalCliques() {
        return totalCliques;
    }

    public void setTotalCliques(int totalCliques) {
        this.totalCliques = totalCliques;
    }

    public int getTotalMoedasTemporarias() {
        return totalMoedasTemporarias;
    }

    public void setTotalMoedasTemporarias(int totalMoedasTemporarias) {
        this.totalMoedasTemporarias = totalMoedasTemporarias;
    }

    /* Filipe Augusto - 20/03/2025 - mob_dev_26_MoedaPermanente */
    public MoedaPermanente getMoedaPermanente() {
        return moedaPermanente;
    }

    public void setMoedaPermanente(MoedaPermanente moedaPermanente) {
        this.moedaPermanente = moedaPermanente;
    }
}
