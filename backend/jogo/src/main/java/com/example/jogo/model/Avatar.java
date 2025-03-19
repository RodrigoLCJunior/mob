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

@Entity
@Table(name = "avatar")
public class Avatar {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private int hp;

    @Column(nullable = false)
    private int danoBase;

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    @OneToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuarios usuario;

    //private List<SkillsAtivas> habilidadesAtivas;

    /* Filipe Augusto - 19/03/2025 - mob_dev_07 */
    @OneToOne
    @JoinColumn(name = "moeda_permanente_id", nullable = false)
    private MoedaPermanente moedaPermanente;

    //Metodo de Criar o Avatar
    public Avatar(int hp, int danoBase, Usuarios usuario) {
        this.moedaPermanente = new MoedaPermanente();
    }

    public Avatar(int hp, int danoBase, Usuarios usuario, MoedaPermanente moedaPermanente) {
        this.hp = hp;
        this.danoBase = danoBase;
        this.usuario = usuario;
        this.moedaPermanente = moedaPermanente; /* Filipe Augusto - 19/03/2025 - mob_dev_07 */
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

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public Usuarios getUsuario() {
        return usuario;
    }

    public void setDanoBase(int danoBase) {
        this.danoBase = danoBase;
    }

    public void setHp(int hp) {
        this.hp = hp;
    }

    public void setUsuario(Usuarios usuario) {
        this.usuario = usuario;
    }

    /* Filipe Augusto - 19/03/2025 - mob_dev_07 */
    public MoedaPermanente getMoedaPermanente() {
        return moedaPermanente;
    }

    public void setMoedaPermanente(MoedaPermanente moedaPermanente) {
        this.moedaPermanente = moedaPermanente;
    }
}
