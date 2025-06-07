var express = require("express");
var router = express.Router();

var medidaTerrenoController = require("../controllers/medidaTerrenoController");

router.get("/sensoresAtivos/:fkLocalidade", function (req, res) {
    medidaTerrenoController.sensoresAtivos(req, res);
});

router.get("/menorUmidade/:fkLocalidade", function (req, res) {
    medidaTerrenoController.menorUmidade(req, res);
});

router.get("/maiorUmidade/:fkLocalidade", function (req, res) {
    medidaTerrenoController.maiorUmidade(req, res);
});

router.get("/aoLongoDia/:fkLocalidade", function (req, res) {
    medidaTerrenoController.aoLongoDia(req, res);
});

router.get("/alertas30dias/:fkLocalidade", function (req, res) {
    medidaTerrenoController.alertas30dias(req, res);
});

router.get("/listarTerrenos/", function (req, res) {
    medidaTerrenoController.listarTerrenos(req, res);
});

module.exports = router;