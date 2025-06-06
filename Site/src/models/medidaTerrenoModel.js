var database = require("../database/config");

function sensoresAtivos(fkLocalidade) {
  var instrucaoSql = `SELECT (SELECT COUNT(*) FROM sensor 
    WHERE status LIKE 'ativo' and fkLocalidade = 1) AS Ativos, COUNT(idSensor) AS Total FROM sensor
    WHERE fkLocalidade = ${fkLocalidade};`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function menorUmidade(fkLocalidade) {
  var instrucaoSql = `SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
    JOIN sensor 
    ON idSensor = fkSensor
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE()AND fkLocalidade = ${fkLocalidade}
    ORDER BY dado ASC LIMIT 1;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function maiorUmidade(fkLocalidade) {
  var instrucaoSql = `SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
    JOIN sensor 
    ON idSensor = fkSensor
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE()AND fkLocalidade = ${fkLocalidade}
    ORDER BY dado DESC LIMIT 1;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function aoLongoDia(fkLocalidade) {
  var instrucaoSql = `SELECT 
  CONCAT(DATE_FORMAT(dataHoraEmissao, '%H'), ':00') AS Hora, 
  ROUND(AVG(dado),1) AS Medida
FROM medida
JOIN sensor ON fkSensor = idSensor
WHERE DATE(dataHoraEmissao) = CURDATE() AND fkLocalidade = ${fkLocalidade}
GROUP BY Hora
ORDER BY Hora DESC;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function alertas30dias(fkLocalidade) {
  var instrucaoSql = `SELECT COUNT(idMedida) AS Quant, DATE_FORMAT(DATE(dataHoraEmissao), '%d/%m') AS Data 
FROM medida
join sensor on fkSensor = idSensor
join localidade on fkLocalidade = idLocalidade
WHERE (dado > 15 OR dado < 13) and fkLocalidade = ${fkLocalidade}
GROUP BY DATE_FORMAT(DATE(dataHoraEmissao), '%d/%m')
ORDER BY DATE_FORMAT(DATE(dataHoraEmissao), '%d/%m') DESC
LIMIT 30;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

module.exports = {
  sensoresAtivos,
  menorUmidade,
  maiorUmidade,
  aoLongoDia,
  alertas30dias,
};
