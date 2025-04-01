package com.example.jogo.repository;

import com.example.jogo.model.MoedaPermanente;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface MoedaPermanenteRepository extends JpaRepository<MoedaPermanente, UUID> {
}
