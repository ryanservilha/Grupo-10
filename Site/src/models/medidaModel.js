var database = require("../database/config");

function buscarMediaTrinta() {

    var instrucaoSql = `SELECT ROUND(AVG(dado), 2) AS umidade, 
    DATE(dataHoraEmissao) AS momento_grafico
    FROM medida
    GROUP BY DATE(dataHoraEmissao)
    ORDER BY momento_grafico DESC
    LIMIT 30;
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarSensoresAtivos() {

    var instrucaoSql = `SELECT (SELECT COUNT(*) FROM sensor 
    WHERE status LIKE 'ativo') AS Ativos, COUNT(idSensor) AS Total FROM sensor;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarqtdAlertas() {

    var instrucaoSql = `SELECT COUNT(*) AS Alertas FROM
    (SELECT terreno AS Terreno, CONCAT(dado, '%') AS Umidade, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Horario FROM medida
    JOIN sensor
    ON fkSensor = idSensor	
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE() AND (dado > 15 OR dado < 13)			
    GROUP BY DATE_FORMAT(dataHoraEmissao, '%H:%i')) AS Subconsulta;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function conteudoAlertas() {
    var instrucaoSql = `SELECT terreno AS Terreno, CONCAT(dado, '%') AS Umidade, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Horario FROM medida
    JOIN sensor
    ON fkSensor = idSensor	
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE() AND (dado > 15 OR dado < 13);`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function menorUmidade() {
    var instrucaoSql = `SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, terreno FROM medida
    JOIN sensor 
    ON idSensor = fkSensor
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE()
    ORDER BY dado ASC LIMIT 1;	
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function maiorUmidade() {
    var instrucaoSql = `SELECT CONCAT(dado,'%') AS TaxaMaior, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, terreno FROM medida
    JOIN sensor 
    ON idSensor = fkSensor
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE()
    ORDER BY dado DESC LIMIT 1;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function aoLongoDia() {
    var instrucaoSql = `select CONCAT(DATE_FORMAT(dataHoraEmissao, '%H'), ':00') AS Hora, round(avg(dado),1) as Medida from medida
    where DATE(dataHoraEmissao) = CURDATE()
    group by DATE_FORMAT(dataHoraEmissao, '%H')
    order by dataHoraEmissao DESC;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
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
