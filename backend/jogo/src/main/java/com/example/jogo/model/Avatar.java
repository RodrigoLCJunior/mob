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

    @OneToMany(mappedBy = "avatar", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AvatarHabilidadeTemporaria> avatarHabilidades;

    //Metodo de Criar o Avatar
    public Avatar(){}

    public Avatar(int hp, int danoBase, Usuarios usuario) {
        this.hp = hp;
        this.danoBase = danoBase;
        this.usuario = usuario;
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

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public Usuarios getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuarios usuario) {
        this.usuario = usuario;
    }

    /* Rodrigo Luiz - 22/03/2025 - mob_028 */
    public List<AvatarHabilidadeTemporaria> getAvatarHabilidades() {
        return avatarHabilidades;
    }

    public void setAvatarHabilidades(List<AvatarHabilidadeTemporaria> avatarHabilidades) {
        this.avatarHabilidades = avatarHabilidades;
    }
}
