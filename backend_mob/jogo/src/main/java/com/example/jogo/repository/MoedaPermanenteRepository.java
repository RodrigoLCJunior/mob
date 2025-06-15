/*
 ** Task..: 26 - Criação da Classe HabilidadesPermanentes
 ** Data..: 29/03/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe para as habilidades
 ** Obs...:
 */

package com.example.jogo.repository;

import com.example.jogo.model.MoedaPermanente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface MoedaPermanenteRepository extends JpaRepository<MoedaPermanente, UUID> {
}
