package com.example.jogo.service;

import com.example.jogo.model.Cards;
import com.example.jogo.repository.CardsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CardsService {

    @Autowired
    private CardsRepository cardsRepository;

    public List<Cards> acharTodasCards() {
        return cardsRepository.findAll();
    }

    public Cards acharCardPorId(Long id) {
        Optional<Cards> cardOpt = cardsRepository.findById(id);
        return cardOpt.orElse(null);
    }

    @Transactional
    public Cards criarCard(Cards cards) {
        if (cards == null ||
                cards.getNome() == null || cards.getNome().trim().isEmpty() ||
                cards.getDescricao() == null || cards.getDescricao().trim().isEmpty() ||
                cards.getImageCard() == null || cards.getImageCard().trim().isEmpty() ||
                cards.getDamage() < 0) {
            throw new IllegalArgumentException("Campos obrigatórios estão vazios ou inválidos");
        }

        Optional<Cards> cardExistente = cardsRepository.findByNome(cards.getNome());
        if (cardExistente.isPresent()) {
            throw new IllegalArgumentException("Carta com esse nome já existe");
        }

        return cardsRepository.save(cards);
    }

    @Transactional
    public Cards modificarCards(Long id, Cards cards) {
        Optional<Cards> cardsOptional = cardsRepository.findById(id);
        if (cardsOptional.isEmpty()) {
            return null;
        }

        if (cards.getNome() == null || cards.getNome().trim().isEmpty() ||
                cards.getDescricao() == null || cards.getDescricao().trim().isEmpty() ||
                cards.getDamage() < 0) {
            throw new IllegalArgumentException("Campos obrigatórios estão vazios ou inválidos");
        }

        Optional<Cards> cardNome = cardsRepository.findByNome(cards.getNome());
        if (cardNome.isPresent()) {
            throw new IllegalArgumentException("Carta com esse nome já existe");
        }

        Cards cardExistente = cardsOptional.get();
        cardExistente.setNome(cards.getNome());
        cardExistente.setDamage(cards.getDamage());
        cardExistente.setDescricao(cards.getDescricao());

        return cardsRepository.save(cardExistente);
    }

    @Transactional
    public void deletarCard(Long id) {
        Optional<Cards> cardsOptional = cardsRepository.findById(id);
        if (cardsOptional.isEmpty()) {
            throw new IllegalArgumentException("Carta com ID " + id + " não encontrada");
        }
        cardsRepository.deleteById(id);
    }
}
