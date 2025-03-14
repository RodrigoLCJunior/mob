/*
 ** Task.....: mob_001
 ** Motivo...: Classe principal do Usuario
 ** Usuario..: Rodrigo Luiz
 ** Data.....: 02/03/2025
 ** Obs......: Muito cuidado com a Autenticação
 */

package com.example.jogo.model;
import jakarta.persistence.*;
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

    /* 07 - 12/03 - Filipe Augusto */
    @OneToOne(cascade = CascadeType.ALL)
    private MoedaPermanente moedaPermanente;

    @Column(nullable = false)
    private int Nivel;

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

    /* 07 - 12/03 - Filipe Augusto */
    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public MoedaPermanente getMoedaPermanente() {
        return moedaPermanente;
    }

    public void setMoedaPermanente(MoedaPermanente moedaPermanente) {
        this.moedaPermanente = moedaPermanente;
    }

    public int getNivel() {
        return Nivel;
    }

    public void setNivel(int nivel) {
        Nivel = nivel;
    }
}
