var medidaModel = require("../models/medidaModel");


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


module.exports = {
    buscarSensoresAtivos,
    buscarqtdAlertas,
    conteudoAlertas,
    menorUmidade,
    maiorUmidade,
 }