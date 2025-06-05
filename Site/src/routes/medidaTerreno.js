var express = require("express");
var router = express.Router();

var medidaTerrenoController = require("../controllers/medidaTerrenoController");

router.get("/sensoresAtivos/", function (req, res) {
    medidaTerrenoController.sensoresAtivos(req, res);
});

router.get("/menorUmidade/", function (req, res) {
    medidaTerrenoController.menorUmidade(req, res);
});

router.get("/maiorUmidade/", function (req, res) {
    medidaTerrenoController.maiorUmidade(req, res);
});

router.get("/aoLongoDia/", function (req, res) {
    medidaTerrenoController.aoLongoDia(req, res);
});

router.get("/alertas30dias/", function (req, res) {
    medidaTerrenoController.alertas30dias(req, res);
});

module.exports = router;