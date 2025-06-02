var database = require("../database/config");

function buscarMediaTrinta(limite_linhas) {

    var instrucaoSql = `SELECT dado as umidade, DATE(dataHoraEmissao) as momento_grafico 
                        FROM medida GROUP BY DATE(dataHoraEmissao)
                        ORDER BY idMedida DESC LIMIT ${limite_linhas};`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarSensoresAtivos() {

    var instrucaoSql = `SELECT (SELECT COUNT(*) FROM sensor 
    WHERE status LIKE 'ativo') AS Ativos, COUNT(idSensor) AS Total FROM sensor;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarMediaTrinta,
    buscarSensoresAtivos
}
