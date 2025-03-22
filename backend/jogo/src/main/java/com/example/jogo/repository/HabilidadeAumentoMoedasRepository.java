/*
 ** Task..: 28 - Criação das classes Habilidades Temporarias
 ** Data..: 22/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Habilidade Temporaria para usar no Combate
 ** Obs...:
 */


package com.example.jogo.repository;

import com.example.jogo.model.HabilidadeAumentoMoedas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HabilidadeAumentoMoedasRepository extends JpaRepository<HabilidadeAumentoMoedas, Integer> {
}
