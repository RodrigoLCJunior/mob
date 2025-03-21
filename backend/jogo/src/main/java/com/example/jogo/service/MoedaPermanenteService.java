/*
 ** Task..: 25 - Moedas Permanentes
 ** Data..: 20/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Classe de Moedas Permanentes
 ** Obs...:
 */

package com.example.jogo.service;

import com.example.jogo.model.MoedaPermanente;
import com.example.jogo.repository.MoedaPermanenteRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class MoedaPermanenteService {

    private final MoedaPermanenteRepository repository;

    public MoedaPermanenteService(MoedaPermanenteRepository repository) {
        this.repository = repository;
    }

    public MoedaPermanente criarMoedaPermanente() {
        return repository.save(new MoedaPermanente());
    }

    public MoedaPermanente buscarPorId(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void adicionarMoedas(Long id, int quantidade) {
        MoedaPermanente moeda = buscarPorId(id);
        if (moeda != null) {
            moeda.adicionarMoedas(quantidade);
            repository.save(moeda);
        }
    }

    public void removerMoedas(Long id, int quantidade) {
        MoedaPermanente moeda = buscarPorId(id);
        if (moeda != null) {
            moeda.removerMoedas(quantidade);
            repository.save(moeda);
        }
    }
}
