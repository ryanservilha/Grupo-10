var database = require("../database/config");

function listarTerrenos() {
  var instrucaoSql = `SELECT COUNT(*) AS Quant FROM localidade;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function sensoresAtivos(fkLocalidade) {
  var instrucaoSql = `SELECT (SELECT COUNT(*) FROM sensor 
    WHERE status LIKE 'ativo' and fkLocalidade = ${fkLocalidade}) AS Ativos, COUNT(idSensor) AS Total FROM sensor
    WHERE fkLocalidade = ${fkLocalidade};`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function menorUmidade(fkLocalidade) {
  var instrucaoSql = `SELECT dado AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
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
  var instrucaoSql = `SELECT dado AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
    JOIN sensor 
    ON idSensor = fkSensor
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE() AND fkLocalidade = ${fkLocalidade}
    ORDER BY dado DESC LIMIT 1;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function aoLongoDia(fkLocalidade) {
  var instrucaoSql = `SELECT ROUND(avg(dado), 1) as dado, date_format(dataHoraEmissao, '%H:%i:%s') as data FROM medida
JOIN sensor ON fkSensor = idSensor
JOIN localidade ON fkLocalidade = idLocalidade
WHERE fkLocalidade = ${fkLocalidade}
GROUP BY dataHoraEmissao, dado
ORDER BY dataHoraEmissao DESC LIMIT 10;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function alertas30dias(fkLocalidade) {
  var instrucaoSql = `SELECT 
    COUNT(*) AS alertas,
    DATE_FORMAT(data, '%d/%m') AS data_formatada
    FROM (
    SELECT DATE(dataHoraEmissao) AS data
    FROM medida
    JOIN sensor ON fkSensor = idSensor
    JOIN localidade ON fkLocalidade = idLocalidade
    WHERE (dado > 15 OR dado < 13) and fkLocalidade = ${fkLocalidade}
   ) AS Subconsulta
  GROUP BY data
  ORDER BY data DESC
  LIMIT 7;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function tempoRealDia(fkLocalidade) {
    var instrucaoSql = `SELECT ROUND(avg(dado), 1) as dado, date_format(dataHoraEmissao, '%H:%i:%s') as data FROM medida
  JOIN sensor ON fkSensor = idSensor
  JOIN localidade ON fkLocalidade = idLocalidade
  WHERE fkLocalidade = ${fkLocalidade}
  GROUP BY dataHoraEmissao, dado
  ORDER BY dataHoraEmissao DESC LIMIT 1;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function tempoRealAlerta(fkLocalidade) {
  var instrucaoSql = `SELECT 
    COUNT(*) AS alertas,
    DATE_FORMAT(data, '%d/%m') AS data_formatada
    FROM (
    SELECT DATE(dataHoraEmissao) AS data
    FROM medida
    JOIN sensor ON fkSensor = idSensor
    JOIN localidade ON fkLocalidade = idLocalidade
    WHERE (dado > 15 OR dado < 13) and fkLocalidade = ${fkLocalidade}
   ) AS Subconsulta
  GROUP BY data
  ORDER BY data DESC
  LIMIT 1;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

module.exports = {
  listarTerrenos,
  sensoresAtivos,
  menorUmidade,
  maiorUmidade,
  aoLongoDia,
  alertas30dias,
  tempoRealDia,
  tempoRealAlerta
};
