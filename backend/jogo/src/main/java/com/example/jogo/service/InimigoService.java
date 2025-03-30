/*
 ** Task..: 13 - Sistema Inicial do Combate
 ** Data..: 08/03/2024
 ** Autor.: Rodrigo Luiz
 ** Motivo: Criar classe Inimigo para usar no Combate
 ** Obs...:
 */

package com.example.jogo.service;
import com.example.jogo.model.Inimigo;
import com.example.jogo.repository.InimigoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InimigoService {

    @Autowired
    private InimigoRepository inimigoRepository;

    public List<Inimigo> findAll(){
        return inimigoRepository.findAll();
    }

    public Optional<Inimigo> findById(int id){
        return inimigoRepository.findById(id);
    }

    public Inimigo modificarInimigo(int id, Inimigo inimigoNovo){
        Inimigo inimigoExistente = inimigoRepository.findById(id).get();

        if (inimigoExistente == null){
            return null;
        }
        inimigoExistente.setHp(inimigoNovo.getHp());
        inimigoExistente.setDanoBase(inimigoNovo.getDanoBase());
        inimigoExistente.setTimeToHit(inimigoNovo.getTimeToHit());
        inimigoExistente.setRecompensa(inimigoNovo.getRecompensa());
        inimigoExistente.setTipo(inimigoNovo.getTipo());

        return salvarInimigo(inimigoExistente);
    }

    public Inimigo salvarInimigo(Inimigo inimigo){
        return inimigoRepository.save(inimigo);
    }

    public void deletarInimigoPorId(int id){
        inimigoRepository.deleteById(id);
    }
}
