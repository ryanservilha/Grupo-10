-- criação do banco de dados
CREATE DATABASE protecaoSoja;

USE protecaoSoja;

-- criação da tabela endereco
CREATE TABLE endereco (
  idEndereco INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  logradouro VARCHAR(100) NOT NULL,
  numero VARCHAR(6) NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  estado CHAR(2) NOT NULL,
  pais VARCHAR(45) NOT NULL
);


-- inserts para endereco
INSERT INTO endereco (logradouro, numero, cidade, estado, pais) VALUES
('Rua das Lavouras', '123', 'Londrina', 'PR', 'Brasil'),
('Av. Soja Forte', '456', 'Sorriso', 'MT', 'Brasil');

-- criação da tabela empresa
CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
razaoSocial VARCHAR(45) NOT NULL,
cnpj CHAR(14) NOT NULL,
codigoVerificacao char(5) NOT NULL UNIQUE,
fkEndereco INT UNIQUE NOT NULL,
CONSTRAINT fkEmpresaEndereco 
FOREIGN KEY (fkEndereco)
REFERENCES endereco(idEndereco)
);

-- inserts para empresa
INSERT INTO empresa (razaoSocial, cnpj, codigoVerificacao, fkEndereco) VALUES
('AgroSoja LTDA', '12345678000199', '12125', 1),
('SojaMax SA', '98765432000155', '34345', 2);

select * from empresa;

-- criação da tabela funcionario
CREATE TABLE funcionario (
  idFuncionario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  nome VARCHAR(60) NOT NULL,
  cpf char(11) NOT NULL,
  email VARCHAR(45) NOT NULL,
  senha VARCHAR(45) NOT NULL,
  setor VARCHAR(45),
  fkGerente INT,
  fkEmpresa INT,
  fkCodigo CHAR(5) NOT NULL,
  CONSTRAINT fkFuncionarioGerente
    FOREIGN KEY (fkGerente)
    REFERENCES funcionario(idFuncionario),
  CONSTRAINT fkFuncionarioEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES empresa(idEmpresa),
  CONSTRAINT fkCodigoVerificacaoEmpresa
  FOREIGN KEY (fkCodigo)
	REFERENCES empresa(codigoVerificacao)
);



-- criação da tabela funcionario
  INSERT INTO funcionario (nome, cpf, email, senha, setor, fkGerente, fkEmpresa, fkCodigo) VALUES
('Carlos Gerente',  '44999999999', 'carlos@empresa.com', 'senha123',  'TI',  NULL, 1, '12125'),
('Ana Engenheira', '44988887777', 'ana@empresa.com',    'senha456', 'Engenharia Agrícola',1, 1, '12125'),
('Bruno Técnico',   '66997776666', 'bruno@empresa.com',  'senha789','Administração', 1,  1, '34345');

  
  select * from funcionario;

-- criação da tabela localidade
CREATE TABLE localidade (
  idLocalidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  terreno VARCHAR(45) NOT NULL, 
  coordenadas VARCHAR(45) NOT NULL UNIQUE
);

-- inserts para localidade
INSERT INTO localidade (terreno, coordenadas) VALUES
('Fazenda Rio Verde', '23S51W'),
('Fazenda Sol Nascente', '12S55W');

-- criação da tabela sensor
CREATE TABLE sensor (
  idSensor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  nome VARCHAR(20) NOT NULL,
  status VARCHAR(7) NOT NULL,
  fkEmpresa INT NOT NULL,
  fkLocalidade INT NOT NULL,
  CONSTRAINT chkStatusSensor CHECK (status IN ('ativo', 'inativo')),
  CONSTRAINT fkSensorEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
  CONSTRAINT fkSensorLocalidade FOREIGN KEY (fkLocalidade) REFERENCES localidade(idLocalidade)
);

select * from sensor;

-- inserts para sensor
INSERT INTO sensor (nome, status, fkEmpresa, fkLocalidade) VALUES
('SensorUmidade', 'ativo', 1, 1),
('SensorPH', 'inativo', 1, 1),
('SensorTemperatura', 'ativo', 2, 2);


-- criação da tabela medida
CREATE TABLE medida (
  idMedida INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  dado DECIMAL(3,1) NOT NULL,
  dataHoraEmissao DATETIME DEFAULT CURRENT_TIMESTAMP,
  fkSensor INT NOT NULL,
  CONSTRAINT fkSensorDado
    FOREIGN KEY (fkSensor)
    REFERENCES sensor(idSensor)
);

INSERT INTO medida (dado, dataHoraEmissao, fkSensor) VALUES
(15.0, '2025-06-05 08:15:00', 1),
(17.5, '2025-06-05 09:00:00', 1),
(13.0, '2025-06-05 10:45:00', 1),
(11.5, '2025-06-05 11:30:00', 1),
(12.0, '2025-06-05 12:15:00', 1);

INSERT INTO medida (dado, dataHoraEmissao, fkSensor) VALUES
(8.6, '2025-06-04 15:26:55', 1);

-- ---------------- DASHBOARD PRINCIPAL -------------------------------------------------

-- SELECT TAXA DE UMIDADE DOS ÚLTIMOS 30 DIAS 
SELECT ROUND(AVG(dado), 2) AS umidade, 
DATE(dataHoraEmissao) AS momento_grafico
FROM medida
GROUP BY DATE(dataHoraEmissao)	
ORDER BY momento_grafico DESC
LIMIT 30;

-- SELECT UMIDADE AO LONGO DO DIA
SELECT 
  Hora,
  ROUND(AVG(Medida), 1) AS Medida,
  MAX(UltimoHorario) AS UltimoHorario
FROM (
  SELECT 
    DATE_FORMAT(dataHoraEmissao, '%H') AS Hora,
    dado AS Medida,
    dataHoraEmissao AS UltimoHorario
  FROM medida
  WHERE DATE(dataHoraEmissao) = CURDATE()
) AS Subconsulta
GROUP BY Hora
ORDER BY UltimoHorario DESC;


-- TOTAL DE SENSORES ATIVOS
SELECT (SELECT COUNT(*) FROM sensor 
WHERE status LIKE 'ativo') AS 'Sensores', COUNT(idSensor) AS 'Total de Sensores' FROM sensor;

-- SELECT QTD DE ALERTAS 
SELECT COUNT(*) AS Alertas FROM (
  SELECT 
    MAX(terreno) AS Terreno, 
    CONCAT(MAX(dado), '%') AS Umidade, 
    DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Horario
  FROM medida
  JOIN sensor ON fkSensor = idSensor	
  JOIN localidade ON fkLocalidade = idLocalidade
  WHERE DATE(dataHoraEmissao) = CURDATE() 
    AND (dado > 15 OR dado < 13)
  GROUP BY DATE_FORMAT(dataHoraEmissao, '%H:%i')
) AS Subconsulta;

-- versão capturando a cada 5 segundos
SELECT COUNT(*) AS Alertas FROM (
  SELECT 
    MAX(terreno) AS Terreno, 
    CONCAT(MAX(dado), '%') AS Umidade, 
    DATE_FORMAT(dataHoraEmissao, '%H:%i:') AS HoraMinuto,
    FLOOR(SECOND(dataHoraEmissao) / 5) * 5 AS SegundoInicio
  FROM medida
  JOIN sensor ON fkSensor = idSensor	
  JOIN localidade ON fkLocalidade = idLocalidade
  WHERE DATE(dataHoraEmissao) = CURDATE() 
    AND (dado > 15 OR dado < 13)
  GROUP BY HoraMinuto, SegundoInicio
) AS Subconsulta;

-- SELECT CONTEUDO ALERTAS 
SELECT terreno AS Terreno, CONCAT(dado, '%') AS Umidade, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Horario FROM medida
JOIN sensor
ON fkSensor = idSensor	
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE() AND (dado > 15 OR dado < 13);

-- SELECT MENOR TAXA DE UMIDADE DO DIA 
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, terreno FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE()
ORDER BY dado ASC LIMIT 1;	

-- SELECT MAIOR TAXA DE UMIDADE DO DIA 
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, terreno FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE()
ORDER BY dado DESC LIMIT 1;
select * from medida;
-- ---------------- DASHBOARD PARA TERRENOS -------------------------------------------------

-- SELECT UMIDADE AO LONGO DO DIA
SELECT 
  CONCAT(DATE_FORMAT(dataHoraEmissao, '%H'), ':00') AS Hora, 
  ROUND(AVG(dado),1) AS Medida
FROM medida
JOIN sensor ON fkSensor = idSensor
WHERE DATE(dataHoraEmissao) = CURDATE() AND fkLocalidade = 1
GROUP BY Hora
ORDER BY Hora DESC;


-- QUANTIDADE DE ALERTAS DURANTE O MÊS
SELECT COUNT(idMedida) AS Quant, DATE_FORMAT(DATE(dataHoraEmissao), '%d/%m') AS Data 
FROM medida
WHERE dado > 15 OR dado < 13
GROUP BY DATE_FORMAT(DATE(dataHoraEmissao), '%d/%m')
ORDER BY DATE_FORMAT(DATE(dataHoraEmissao), '%d/%m') DESC
LIMIT 30;


-- SELECT QUANTIDADE DE SENSORES ATIVOS NAQUELE TERRENO
SELECT (SELECT COUNT(*) FROM sensor 
    WHERE status LIKE 'ativo' and fkLocalidade = 1) AS Ativos, COUNT(idSensor) AS Total FROM sensor
    WHERE fkLocalidade = 1;

-- SELECT MENOR TAXA DE UMIDADE DO DIA NAQUELE TERRENO
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE() AND fkLocalidade = 1
ORDER BY dado ASC LIMIT 1;

-- SELECT MAIOR TAXA DE UMIDADE DO DIA NAQUELE TERRENO
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE()AND fkLocalidade = 1
ORDER BY dado DESC LIMIT 1;
