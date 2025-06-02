var express = require("express");
var router = express.Router();

var medidaController = require("../controllers/medidaController");

router.get("/media-trinta-dias/", function (req, res) {
    medidaController.buscarMediaTrinta(req, res);
});

router.get("/sensoresAtivos/", function (req, res) {
    medidaController.buscarSensoresAtivos(req, res);
});

module.exports = router;