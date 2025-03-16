/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 09/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Dungeon para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "dungeon")
public class Dungeon {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private int numeroWaves;

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @Column(nullable = false)
    private boolean concluida;

    @Column(nullable = false)
    private boolean bloqueada;

    @OneToMany(mappedBy = "dungeon", cascade = CascadeType.ALL)
    private List<Wave> waves;

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuarios usuario;

    // Construtores, getters e setters

    public Dungeon() {
    }

    public Dungeon(String nome, List<Wave> waves) {
        this.nome = nome;
        this.waves = waves;
    }

    public int getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public List<Wave> getWaves() {
        return waves;
    }

    public void setWaves(List<Wave> waves) {
        this.waves = waves;
    }

    public int getNumeroWaves() {
        return numeroWaves;
    }

    public void setNumeroWaves(int numeroWaves) {
        this.numeroWaves = numeroWaves;
    }

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */

    public Usuarios getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuarios usuario) {
        this.usuario = usuario;
    }

    public boolean isConcluida() {
        return concluida;
    }

    public void setConcluida(boolean concluida) {
        this.concluida = concluida;
    }

    public boolean isBloqueada() {
        return bloqueada;
    }

    public void setBloqueada(boolean desbloqueada) {
        this.bloqueada = desbloqueada;
    }
}
