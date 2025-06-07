var database = require("../database/config");

function buscarSensoresAtivos() {
  var instrucaoSql = `SELECT (SELECT COUNT(*) FROM sensor 
    WHERE status LIKE 'ativo') AS Ativos, COUNT(idSensor) AS Total FROM sensor;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function buscarqtdAlertas() {
  var instrucaoSql = `  select COUNT(idMedida) as Alertas FROM medida
  where (dado > 15 or dado < 13) and date(dataHoraEmissao) = CURDATE();`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function conteudoAlertas() {
  var instrucaoSql = ` SELECT terreno, dado, DATE_FORMAT(dataHoraEmissao, '%d-%m-%Y %H:%i') as data FROM medida
  JOIN sensor ON fkSensor = idSensor
  JOIN localidade ON fkLocalidade = idLocalidade
  WHERE (dado > 15 or dado < 13) and date(dataHoraEmissao) = CURDATE()
  ORDER BY dataHoraEmissao DESC;`;

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
  var instrucaoSql = `SELECT CONCAT(dado,'%') AS TaxaMaior, 
  DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, 
  terreno FROM medida
    JOIN sensor 
    ON idSensor = fkSensor
    JOIN localidade 
    ON fkLocalidade = idLocalidade
    WHERE DATE(dataHoraEmissao) = CURDATE()
    ORDER BY dado DESC LIMIT 1;`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

module.exports = {
  buscarSensoresAtivos,
  buscarqtdAlertas,
  conteudoAlertas,
  menorUmidade,
  maiorUmidade,
};
