/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.repository;
import com.example.jogo.model.Inimigo;
import org.springframework.data.jpa.repository.JpaRepository;
public interface InimigoRepository extends JpaRepository<Inimigo, Integer> {
}
