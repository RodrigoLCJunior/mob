/*
 ** Task..: 26 - Habilidades Permanentes
 ** Data..: 24/03/2024
 ** Autor.: Filipe Augusto
 ** Motivo: Repository de Evoluir Habilidades Permanentes
 ** Obs...: Vai ser alterado ainda
 */

package com.example.jogo.repository;

import com.example.jogo.model.Avatar;
import com.example.jogo.model.EvoluirAtributo;
import com.example.jogo.model.TipoAtributo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface EvoluirAtributoRepository extends JpaRepository<EvoluirAtributo, UUID> {

    Optional<EvoluirAtributo> findByAvatarAndTipoAtributo(Avatar avatar, TipoAtributo tipoAtributo);
}
