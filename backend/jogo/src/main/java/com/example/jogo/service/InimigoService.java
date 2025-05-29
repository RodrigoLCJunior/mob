package com.example.jogo.service;

import com.example.jogo.model.Cards;
import com.example.jogo.model.Inimigo;
import com.example.jogo.repository.CardsRepository;
import com.example.jogo.repository.InimigoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class InimigoService {

    @Autowired
    private InimigoRepository inimigoRepository;

    @Autowired
    private CardsService cardsService;

    private final Random random = new Random();

    public List<Inimigo> findAll() {
        return inimigoRepository.findAll();
    }

    public Optional<Inimigo> findById(Long id) {
        return inimigoRepository.findById(id);
    }

    @Transactional
    public Inimigo salvarInimigo(Inimigo inimigo) {
        if (inimigo == null) {
            throw new IllegalArgumentException("Inimigo não pode ser nulo");
        }

        // Aqui você pode adicionar outras validações se quiser
        return inimigoRepository.save(inimigo);
    }

    public Inimigo modificarInimigo(Long id, Inimigo inimigoNovo) {
        Optional<Inimigo> inimigoOpt = inimigoRepository.findById(id);
        if (inimigoOpt.isEmpty()) {
            return null;
        }
        Inimigo inimigoExistente = inimigoOpt.get();
        if (inimigoNovo.getHp() < 0 || inimigoNovo.getRecompensa() < 0) {
            throw new IllegalArgumentException("HP e recompensa não podem ser negativos");
        }
        inimigoExistente.setHp(inimigoNovo.getHp());
        inimigoExistente.setRecompensa(inimigoNovo.getRecompensa());
        return inimigoRepository.save(inimigoExistente);
    }

    public Inimigo adicionarCartaAoDeckPorNumero(Long inimigoId, Long numeroCarta) {
        Inimigo inimigo = inimigoRepository.findById(inimigoId).orElse(null);
        if (inimigo == null) {
            throw new IllegalArgumentException("Inimigo não encontrado");
        }
        Cards carta = cardsService.acharCardPorId(numeroCarta);
        if (carta == null) {
            throw new IllegalArgumentException("Carta com número " + numeroCarta + " não encontrada");
        }
        if (inimigo.getDeck() == null) {
            inimigo.setDeck(new ArrayList<>());
        }
        if (!inimigo.getDeck().contains(carta)) {
            inimigo.getDeck().add(carta);
        }
        return inimigoRepository.save(inimigo);
    }

    public Inimigo geraInimigoAleatorio(){
        List<Inimigo> todosInimigos = findAll();
        if (todosInimigos.isEmpty()){
            return null;
        }

        Inimigo inimigoAleatorio = todosInimigos.get(random.nextInt(todosInimigos.size()));
        if (inimigoAleatorio == null){
            return null;
        }
        return inimigoAleatorio;
    };

    @Transactional
    public void deletarInimigoPorId(Long id) {
        Optional<Inimigo> inimigoOpt = inimigoRepository.findById(id);
        if (inimigoOpt.isEmpty()) {
            throw new IllegalArgumentException("Inimigo com ID " + id + " não encontrado");
        }
        inimigoRepository.deleteById(id);
    }
}
