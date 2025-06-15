/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.model;

public class MoedaTemporaria {
    private int quantidade;

    public MoedaTemporaria(){
        this.quantidade = 0;
    }

    public MoedaTemporaria(int quantidade){
        this.quantidade = quantidade;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public void adicionarMoedas(int quantidade){
        this.quantidade += quantidade;
    }

    public void  removerMoedas(int quantidade){
        this.quantidade -= quantidade;
        if(this.quantidade < 0){
            this.quantidade = 0;
        }
    }

}
