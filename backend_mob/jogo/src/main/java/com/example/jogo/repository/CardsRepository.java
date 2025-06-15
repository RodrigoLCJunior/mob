package com.example.jogo.repository;

import com.example.jogo.model.Cards;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CardsRepository extends JpaRepository<Cards, Long>{
    Optional<Cards> findByNome(String nome);
}
