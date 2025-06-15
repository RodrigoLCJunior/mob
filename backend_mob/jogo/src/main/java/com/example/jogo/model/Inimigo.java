/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "inimigos")
public class Inimigo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private int hp;

    @Column(nullable = false)
    private int recompensa;

    @Column
    private String imageInimigo;

    @ManyToMany
    @JoinTable(
            name = "inimigo_cards",
            joinColumns = @JoinColumn(name = "inimigo_id"),
            inverseJoinColumns = @JoinColumn(name = "card_id")
    )
    private List<Cards> deck = new ArrayList<>();

    public Inimigo(){}

    public Inimigo(Long id, String nome, int hp, int recompensa) {
        this.id = id;
        this.nome = nome; /* Rodrigo Luiz - 30/03/2025 - mob_031 */
        this.hp = hp;
        this.recompensa = recompensa;
        this.imageInimigo = ""; // Valor padrão null
    }

    public void setHp(int hp) {
        this.hp = hp;
    }

    public void setRecompensa(int recompensa) {
        this.recompensa = recompensa;
    }

    public int getRecompensa() {
        return recompensa;
    }

    public int getHp() {
        return hp;
    }

    public Long getId() {
        return id;
    }

    /* Rodrigo Luiz - 30/03/2025 - mob_031 */
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public List<Cards> getDeck() {
        return deck;
    }

    public void setDeck(List<Cards> deck) {
        this.deck = deck;
    }

    public String getImageInimigo() {
        return imageInimigo;
    }

    public void setImageInimigo(String imageInimigo) {
        this.imageInimigo = imageInimigo;
    }
}
