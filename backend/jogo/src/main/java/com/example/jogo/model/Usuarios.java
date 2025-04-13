/*
 ** Task.....: mob_001
 ** Motivo...: Classe principal do Usuario
 ** Usuario..: Rodrigo Luiz
 ** Data.....: 02/03/2025
 ** Obs......: Muito cuidado com a Autenticação
 */

package com.example.jogo.model;
import jakarta.persistence.*;

import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "usuarios")
public class Usuarios {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String senha;  // Armazenada de forma segura (hash)

    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "avatar_id", referencedColumnName = "id")
    private Avatar avatar;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "moeda_permanente_id", referencedColumnName = "id")
    private MoedaPermanente moedaPermanente;

    /*
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Dungeon> dungeons;
    */

    public Usuarios() {} 

    public Usuarios(String nome, String email, String senha) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
    }

    public UUID getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public String getEmail() {
        return email;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    /* Rodrigo Luiz - 15/03/2025 - mob_015 */
    public Avatar getAvatar() {
        return avatar;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    /*
    public List<Dungeon> getDungeons() {
        return dungeons;
    }

    public void setDungeons(List<Dungeon> dungeons) {
        this.dungeons = dungeons;
    }
    */

    public MoedaPermanente getMoedaPermanente() {
        return moedaPermanente;
    }

    public void setMoedaPermanente(MoedaPermanente moedaPermanente) {
        this.moedaPermanente = moedaPermanente;
    }
}
