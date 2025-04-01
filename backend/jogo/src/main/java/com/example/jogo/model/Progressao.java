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
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int totalMoedasTemporarias;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int totalCliques;

    @Column(nullable = false, columnDefinition = "integer default 0")
    private int totalInimigosDerrotados;

    @Column(nullable = false)
    private UUID avatarId;

    public Progressao(){}

    public Progressao(int totalMoedasTemporarias, int totalCliques, int totalInimigosDerrotados){
        this.totalMoedasTemporarias = totalMoedasTemporarias;
        this.totalCliques = totalCliques;
        this.totalInimigosDerrotados = totalInimigosDerrotados;
    }

    public UUID getId() {
        return id;
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

    public UUID getAvatarId() {
        return avatarId;
    }

    public void setAvatarId(UUID avatarId) {
        this.avatarId = avatarId;
    }
}
