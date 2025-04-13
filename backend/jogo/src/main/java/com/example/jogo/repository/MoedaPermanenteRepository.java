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

import java.util.UUID;

public interface MoedaPermanenteRepository extends JpaRepository<MoedaPermanente, UUID> {
}
