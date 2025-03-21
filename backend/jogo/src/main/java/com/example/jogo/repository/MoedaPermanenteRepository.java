/*
 ** Task..: 25 - Moedas Permanentes
 ** Data..: 20/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Classe de Moedas Permanentes
 ** Obs...:
 */

package com.example.jogo.repository;

import com.example.jogo.model.MoedaPermanente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MoedaPermanenteRepository extends JpaRepository<MoedaPermanente, Long> {
}
