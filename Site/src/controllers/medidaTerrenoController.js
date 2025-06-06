var medidaTerrenoModel = require("../models/medidaTerrenoModel");

function sensoresAtivos(req, res) {

    const fkLocalidade = req.params.fkLocalidade;

    medidaTerrenoModel.sensoresAtivos(fkLocalidade).then(function (resultado) {
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

function menorUmidade(req, res) {
    const fkLocalidade = req.params.fkLocalidade;

    medidaTerrenoModel.menorUmidade(fkLocalidade).then(function (resultado) {
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

function maiorUmidade(req, res) {
    const fkLocalidade = req.params.fkLocalidade;

    medidaTerrenoModel.maiorUmidade(fkLocalidade).then(function (resultado) {
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

function aoLongoDia(req, res) {
    const fkLocalidade = req.params.fkLocalidade;

    medidaTerrenoModel.aoLongoDia(fkLocalidade).then(function (resultado) {
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


function alertas30dias(req, res) {
    const fkLocalidade = req.params.fkLocalidade;

    medidaTerrenoModel.alertas30dias(fkLocalidade).then(function (resultado) {
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

module.exports = {
    sensoresAtivos,
    menorUmidade,
    maiorUmidade,
    aoLongoDia,
    alertas30dias
}