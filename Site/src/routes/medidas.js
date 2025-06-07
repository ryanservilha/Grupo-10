var express = require("express");
var router = express.Router();

var medidaController = require("../controllers/medidaController");

router.get("/sensoresAtivos/", function (req, res) {
    medidaController.buscarSensoresAtivos(req, res);
});

router.get("/qtdAlertas/", function (req, res) {
    medidaController.buscarqtdAlertas(req, res);
});

router.get("/conteudoAlertas/", function (req, res) {
    medidaController.conteudoAlertas(req, res);
});

router.get("/menorUmidade/", function (req, res) {
    medidaController.menorUmidade(req, res);
});

router.get("/maiorUmidade/", function (req, res) {
    medidaController.maiorUmidade(req, res);
});

module.exports = router;