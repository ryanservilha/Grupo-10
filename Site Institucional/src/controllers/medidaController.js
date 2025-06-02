var medidaModel = require("../models/medidaModel");

function buscarMediaTrinta(req, res) {

    const limite_linhas = 30;

    // var idFuncionario = req.params.idFuncionario;

    medidaModel.buscarMediaTrinta(limite_linhas).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!")
        }
    }).catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function buscarSensoresAtivos(req, res) {
    medidaModel.buscarSensoresAtivos().then(function (resultado) {
        res.status(200).json(resultado);
    }).catch(function (erro) {
        res.status(500).json(erro.sqlMessage);
    })
}


module.exports = {
    buscarMediaTrinta,
    buscarSensoresAtivos
}