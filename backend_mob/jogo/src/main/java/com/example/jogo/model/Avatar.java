/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Avatar para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;
import jakarta.persistence.*;

import java.util.ArrayList;
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

    /* Rodrigo Luiz - 18/03/2025 - mob_018 */
    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    private Progressao progressao;

    @ManyToMany
    @JoinTable(
            name = "avatar_cards",
            joinColumns = @JoinColumn(name = "avatar_id"),
            inverseJoinColumns = @JoinColumn(name = "card_id")
    )
    private List<Cards> deck = new ArrayList<>();

    //private List<SkillsAtivas> habilidadesAtivas;

    //Metodo de Criar o Avatar
    public Avatar(){}

    public Avatar(int hp) {
        this.hp = hp;
    }

    public int getHp() {
        return hp;
    }

    public UUID getId() {
        return id;
    }

    public void setHp(int hp) {
        this.hp = hp;
    }

    /* Rodrigo Luiz - 18/03/2025 - mob_018 */
    public Progressao getProgressao() {
        return progressao;
    }

    public void setProgressao(Progressao progressao) {
        this.progressao = progressao;
    }

    public List<Cards> getDeck() {
        return deck;
    }

    public void setDeck(List<Cards> deck) {
        this.deck = deck;
    }
}
