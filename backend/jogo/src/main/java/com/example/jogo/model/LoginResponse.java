/*
 ** Task..: 31 - Conexão Back e Front
 ** Data..: 03/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe para resposta
 ** Obs...:
 */

package com.example.jogo.model;

public class LoginResponse {
    private boolean success;
    private String error; // "email", "senha", "generic"
    private String message;
    private Usuarios user; // Dados do usuário em caso de sucesso

    // Construtores
    public LoginResponse(boolean success, String error, String message, Usuarios user) {
        this.success = success;
        this.error = error;
        this.message = message;
        this.user = user;
    }

    // Getters e Setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Usuarios getUser() {
        return user;
    }

    public void setUser(Usuarios user) {
        this.user = user;
    }
}