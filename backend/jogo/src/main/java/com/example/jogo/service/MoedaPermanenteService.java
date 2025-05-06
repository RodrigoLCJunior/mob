/*
 ** Task..: 26 - Criação da Classe HabilidadesPermanentes
 ** Data..: 29/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe para as habilidades
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.repository.MoedaPermanenteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class MoedaPermanenteService {

    @Autowired
    private MoedaPermanenteRepository moedaPermanenteRepository;

    public MoedaPermanente criarMoedaPermanente() {
        MoedaPermanente moedaPermanente = new MoedaPermanente();
        return moedaPermanenteRepository.save(moedaPermanente);
    }

    public MoedaPermanente buscarMoedaPermanente(UUID id) {
        return moedaPermanenteRepository.findById(id).orElseThrow(() -> new IllegalStateException("MoedaPermanente não encontrada."));
    }

    @Transactional
    public MoedaPermanente modificarMoedaPermanente(UUID id, int quantidade) {
        if (quantidade < 0) {
            throw new IllegalArgumentException("Quantidade não pode ser negativa");
        }
        MoedaPermanente moedaPermanente = buscarMoedaPermanente(id);
        moedaPermanente.setQuantidade(quantidade);
        return moedaPermanenteRepository.save(moedaPermanente);
    }

    @Transactional
    public void deletarMoedaPermanente(UUID id) {
        MoedaPermanente moedaPermanente = buscarMoedaPermanente(id);
        moedaPermanenteRepository.delete(moedaPermanente);
    }

    @Transactional
    public MoedaPermanente ganharMoedas(UUID id, int quantidade) {
        if (quantidade < 0) {
            throw new IllegalArgumentException("Quantidade não pode ser negativa");
        }
        MoedaPermanente moedaPermanente = buscarMoedaPermanente(id);
        moedaPermanente.setQuantidade(moedaPermanente.getQuantidade() + quantidade);
        return moedaPermanenteRepository.save(moedaPermanente);
    }

    @Transactional
    public MoedaPermanente gastarMoedas(UUID id, int quantidade) {
        if (quantidade < 0) {
            throw new IllegalArgumentException("Quantidade não pode ser negativa");
        }
        MoedaPermanente moedaPermanente = buscarMoedaPermanente(id);
        if (moedaPermanente.getQuantidade() >= quantidade) {
            moedaPermanente.setQuantidade(moedaPermanente.getQuantidade() - quantidade);
        } else {
            throw new IllegalStateException("Quantidade insuficiente de moedas.");
        }
        return moedaPermanenteRepository.save(moedaPermanente);
    }
}