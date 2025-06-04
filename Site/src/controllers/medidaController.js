var medidaModel = require("../models/medidaModel");

function buscarMediaTrinta(req, res) {

    // var idFuncionario = req.params.idFuncionario;

    medidaModel.buscarMediaTrinta().then(function (resultado) {
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

function buscarqtdAlertas(req, res) {
    medidaModel.buscarqtdAlertas().then(function (resultado) {
        res.status(200).json(resultado);
    }).catch(function (erro) {
        res.status(500).json(erro.sqlMessage);
    })
}

function conteudoAlertas(req, res) {
    medidaModel.conteudoAlertas().then(function (resultado) {
        res.status(200).json(resultado);
    }).catch(function (erro) {
        res.status(500).json(erro.sqlMessage);
    })
}

function menorUmidade(req, res) {
    medidaModel.menorUmidade().then(function (resultado) {
        res.status(200).json(resultado);
    }).catch(function (erro) {
        res.status(500).json(erro.sqlMessage);
    })
}

function maiorUmidade(req, res) {
    medidaModel.maiorUmidade().then(function (resultado) {
        res.status(200).json(resultado);
    }).catch(function (erro) {
        res.status(500).json(erro.sqlMessage);
    })
}

function aoLongoDia(req, res) {
    medidaModel.aoLongoDia().then(function (resultado) {
        res.status(200).json(resultado);
    }).catch(function (erro) {
        res.status(500).json(erro.sqlMessage);
    })
}


module.exports = {
    buscarMediaTrinta,
    buscarSensoresAtivos,
    buscarqtdAlertas,
    conteudoAlertas,
    menorUmidade,
    maiorUmidade,
    aoLongoDia
}