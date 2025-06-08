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

-- criação da tabela localidade
CREATE TABLE localidade (
  idLocalidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  terreno VARCHAR(45) NOT NULL, 
  coordenadas VARCHAR(45) NOT NULL UNIQUE
);

-- inserts para localidade
INSERT INTO localidade (terreno, coordenadas) VALUES
('Terreno 1', '23S51W'),
('Terreno 2', '12S55W');

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


-- ---------------- DASHBOARD PRINCIPAL -------------------------------------------------

-- Quantidade de sensores ativos
SELECT (SELECT COUNT(*) FROM sensor 
WHERE status LIKE 'ativo') AS Ativos, COUNT(idSensor) AS Total FROM sensor;

-- Quantidade de alertas do dia
select COUNT(idMedida) as Alertas FROM medida
where (dado > 15 or dado < 13) and date(dataHoraEmissao) = CURDATE();

-- Conteudo dos alertas, do dia
SELECT terreno, dado, DATE_FORMAT(dataHoraEmissao, '%d-%m-%Y %H:%i') as data FROM medida
  JOIN sensor ON fkSensor = idSensor
  JOIN localidade ON fkLocalidade = idLocalidade
  WHERE (dado > 15 or dado < 13) and date(dataHoraEmissao) = CURDATE()
  ORDER BY dataHoraEmissao DESC;
  
-- Menor umidade captada do dia
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, terreno FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE()
ORDER BY dado ASC LIMIT 1;	   

-- Maior umidade captada do dia
SELECT CONCAT(dado,'%') AS TaxaMaior, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora, terreno 
FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE()
ORDER BY dado DESC LIMIT 1;

-- ---------------- DASHBOARD TERRENOS ESPECÍFICOS -------------------------------------------------
-- Quantidade de sensores ativos
SELECT (SELECT COUNT(*) FROM sensor 
WHERE status LIKE 'ativo' and fkLocalidade = 1) AS Ativos, COUNT(idSensor) AS Total FROM sensor
WHERE fkLocalidade = 1;
    
-- Menor taxa de umidade captada 
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE() AND fkLocalidade = 1
ORDER BY dado ASC LIMIT 1;

-- Maior taxa de umidade captada
SELECT CONCAT(dado,'%') AS Taxa, DATE_FORMAT(dataHoraEmissao, '%H:%i') AS Hora FROM medida
JOIN sensor 
ON idSensor = fkSensor
JOIN localidade 
ON fkLocalidade = idLocalidade
WHERE DATE(dataHoraEmissao) = CURDATE() AND fkLocalidade = 1
ORDER BY dado DESC LIMIT 1;

-- Gráfico taxa de umidade ao longo do dia
SELECT ROUND(avg(dado), 1) as dado, date_format(dataHoraEmissao, '%H:%i:%s') as data FROM medida
JOIN sensor ON fkSensor = idSensor
JOIN localidade ON fkLocalidade = idLocalidade
WHERE fkLocalidade = 1 
GROUP BY dataHoraEmissao, dado
ORDER BY dataHoraEmissao DESC LIMIT 10;

-- Gráfico quantidade de alertas ao longo de 7 dias
SELECT COUNT(*) AS alertas, DATE_FORMAT(data, '%d/%m') AS data_formatada 
FROM (
    SELECT DATE(dataHoraEmissao) AS data
    FROM medida
    JOIN sensor ON fkSensor = idSensor
    JOIN localidade ON fkLocalidade = idLocalidade
    WHERE (dado > 15 OR dado < 13) and fkLocalidade = 1
   ) AS Subconsulta
  GROUP BY data
  ORDER BY data DESC
  LIMIT 7;

-- --------------------------- INSERTS ------------------------------------------------------
INSERT INTO endereco (logradouro, numero, cidade, estado, pais) VALUES
('Rua das Lavouras', '123', 'Londrina', 'PR', 'Brasil'),
('Av. Soja Forte', '456', 'Sorriso', 'MT', 'Brasil');

-- inserts para empresa
INSERT INTO empresa (razaoSocial, cnpj, codigoVerificacao, fkEndereco) VALUES
('AgroSoja LTDA', '12345678000199', '12125', 1),
('SojaMax SA', '98765432000155', '34345', 2);

INSERT INTO sensor VALUES
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'inativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'inativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2),
(default, 'Umidade Capacitivo', 'inativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2),
(default, 'Umidade Capacitivo', 'ativo', 1, 2);

INSERT INTO funcionario (nome, cpf, email, senha, setor, fkGerente, fkEmpresa, fkCodigo) VALUES
('Carlos Gerente',  '44999999999', 'carlos@empresa.com', 'senha123',  'TI',  NULL, 1, '12125'),
('Ana Engenheira', '44988887777', 'ana@empresa.com',    'senha456', 'Engenharia Agrícola',1, 1, '12125'),
('Bruno Técnico',   '66997776666', 'bruno@empresa.com',  'senha789','Administração', 1,  1, '34345');


INSERT INTO medida VALUES
(default, 11, '2025-06-02 08:00:00', 1),
(default, 14, '2025-06-02 09:00:00', 1),
(default, 15, '2025-06-02 10:00:00', 1),
(default, 13, '2025-06-02 11:00:00', 1),
(default, 14, '2025-06-02 12:00:00', 1),
(default, 15, '2025-06-02 13:00:00', 1),
(default, 13, '2025-06-02 14:00:00', 1),
(default, 14, '2025-06-02 15:00:00', 1),
(default, 15, '2025-06-02 16:00:00', 1),
(default, 13, '2025-06-02 17:00:00', 1),

-- 2025-06-03
(default, 14, '2025-06-03 08:00:00', 1),
(default, 15, '2025-06-03 09:00:00', 1),
(default, 13, '2025-06-03 10:00:00', 1),
(default, 14, '2025-06-03 11:00:00', 1),
(default, 15, '2025-06-03 12:00:00', 1),
(default, 13, '2025-06-03 13:00:00', 1),
(default, 14, '2025-06-03 14:00:00', 1),
(default, 12, '2025-06-03 15:00:00', 1),
(default, 13, '2025-06-03 16:00:00', 1),
(default, 14, '2025-06-03 17:00:00', 1),

-- 2025-06-04
(default, 15, '2025-06-04 08:00:00', 1),
(default, 13, '2025-06-04 09:00:00', 1),
(default, 14, '2025-06-04 10:00:00', 1),
(default, 15, '2025-06-04 11:00:00', 1),
(default, 13, '2025-06-04 12:00:00', 1),
(default, 12, '2025-06-04 13:00:00', 1),
(default, 15, '2025-06-04 14:00:00', 1),
(default, 13, '2025-06-04 15:00:00', 1),
(default, 14, '2025-06-04 16:00:00', 1),
(default, 15, '2025-06-04 17:00:00', 1),

-- 2025-06-05
(default, 13, '2025-06-05 08:00:00', 1),
(default, 14, '2025-06-05 09:00:00', 1),
(default, 15, '2025-06-05 10:00:00', 1),
(default, 13, '2025-06-05 11:00:00', 1),
(default, 14, '2025-06-05 12:00:00', 1),
(default, 11, '2025-06-05 13:00:00', 1),
(default, 13, '2025-06-05 14:00:00', 1),
(default, 14, '2025-06-05 15:00:00', 1),
(default, 15, '2025-06-05 16:00:00', 1),
(default, 13, '2025-06-05 17:00:00', 1),

-- 2025-06-06
(default, 11, '2025-06-06 08:00:00', 1),
(default, 15, '2025-06-06 09:00:00', 1),
(default, 13, '2025-06-06 10:00:00', 1),
(default, 12, '2025-06-06 11:00:00', 1),
(default, 13, '2025-06-06 12:00:00', 1),
(default, 13, '2025-06-06 13:00:00', 1),
(default, 14, '2025-06-06 14:00:00', 1),
(default, 15, '2025-06-06 15:00:00', 1),
(default, 13, '2025-06-06 16:00:00', 1),
(default, 14, '2025-06-06 17:00:00', 1),

-- 2025-06-07
(default, 15, '2025-06-07 08:00:00', 1),
(default, 11, '2025-06-07 09:00:00', 1),
(default, 14, '2025-06-07 10:00:00', 1),
(default, 15, '2025-06-07 11:00:00', 1),
(default, 13, '2025-06-07 12:00:00', 1),
(default, 14, '2025-06-07 13:00:00', 1),
(default, 15, '2025-06-07 14:00:00', 1),
(default, 13, '2025-06-07 15:00:00', 1),
(default, 14, '2025-06-07 16:00:00', 1),
(default, 15, '2025-06-07 17:00:00', 1),

-- 2025-06-08
(default, 13, '2025-06-08 08:00:00', 1),
(default, 14, '2025-06-08 09:00:00', 1),
(default, 15, '2025-06-08 10:00:00', 1),
(default, 13, '2025-06-08 11:00:00', 1),
(default, 14, '2025-06-08 12:00:00', 1),
(default, 15, '2025-06-08 13:00:00', 1),
(default, 13, '2025-06-08 14:00:00', 1),
(default, 14, '2025-06-08 15:00:00', 1),
(default, 15, '2025-06-08 16:00:00', 1),
(default, 13, '2025-06-08 17:00:00', 1);
-- ---------------------- TERRENO 2 -----------------------------
INSERT INTO medida VALUES
-- 2025-06-02
(default, 13, '2025-06-02 08:00:00', 10),
(default, 14, '2025-06-02 09:00:00', 10),
(default, 15, '2025-06-02 10:00:00', 10),
(default, 11, '2025-06-02 11:00:00', 10),
(default, 13, '2025-06-02 12:00:00', 10),
(default, 14, '2025-06-02 13:00:00', 10),
(default, 13, '2025-06-02 14:00:00', 10),
(default, 13, '2025-06-02 15:00:00', 10),
(default, 13, '2025-06-02 16:00:00', 10),
(default, 13, '2025-06-02 17:00:00', 10),

-- 2025-06-03
(default, 14, '2025-06-03 08:00:00', 10),
(default, 13, '2025-06-03 09:00:00', 10),
(default, 15, '2025-06-03 10:00:00', 10),
(default, 13.5, '2025-06-03 11:00:00', 10),
(default, 13, '2025-06-03 12:00:00', 10),
(default, 13, '2025-06-03 13:00:00', 10),
(default, 14, '2025-06-03 14:00:00', 10),
(default, 14, '2025-06-03 15:00:00', 10),
(default, 15, '2025-06-03 16:00:00', 10),
(default, 11, '2025-06-03 17:00:00', 10),

-- 2025-06-04
(default, 13, '2025-06-04 08:00:00', 10),
(default, 13, '2025-06-04 09:00:00', 10),
(default, 14, '2025-06-04 10:00:00', 10),
(default, 15, '2025-06-04 11:00:00', 10),
(default, 15, '2025-06-04 12:00:00', 10),
(default, 13, '2025-06-04 13:00:00', 10),
(default, 13, '2025-06-04 14:00:00', 10),
(default, 14, '2025-06-04 15:00:00', 10),
(default, 12, '2025-06-04 16:00:00', 10),
(default, 14, '2025-06-04 17:00:00', 10),

-- 2025-06-05
(default, 14, '2025-06-05 08:00:00', 10),
(default, 12, '2025-06-05 09:00:00', 10),
(default, 15, '2025-06-05 10:00:00', 10),
(default, 15, '2025-06-05 11:00:00', 10),
(default, 13, '2025-06-05 12:00:00', 10),
(default, 14, '2025-06-05 13:00:00', 10),
(default, 15, '2025-06-05 14:00:00', 10),
(default, 15, '2025-06-05 15:00:00', 10),
(default, 13, '2025-06-05 16:00:00', 10),
(default, 13, '2025-06-05 17:00:00', 10),	

-- 2025-06-06
(default, 11, '2025-06-06 08:00:00', 10),
(default, 15, '2025-06-06 09:00:00', 10),
(default, 15, '2025-06-06 10:00:00', 10),
(default, 15, '2025-06-06 11:00:00', 10),
(default, 13, '2025-06-06 12:00:00', 10),
(default, 13, '2025-06-06 13:00:00', 10),
(default, 14, '2025-06-06 14:00:00', 10),
(default, 15, '2025-06-06 15:00:00', 10),
(default, 13, '2025-06-06 16:00:00', 10),
(default, 14, '2025-06-06 17:00:00', 10),

-- 2025-06-07
(default, 14, '2025-06-07 08:00:00', 10),
(default, 13, '2025-06-07 09:00:00', 10),
(default, 15, '2025-06-07 10:00:00', 10),
(default, 13, '2025-06-07 11:00:00', 10),
(default, 13, '2025-06-07 12:00:00', 10),
(default, 12, '2025-06-07 13:00:00', 10),
(default, 14, '2025-06-07 14:00:00', 10),
(default, 15, '2025-06-07 15:00:00', 10),
(default, 12, '2025-06-07 16:00:00', 10),
(default, 15, '2025-06-07 17:00:00', 10),

-- 2025-06-08
(default, 13, '2025-06-08 08:00:00', 10),
(default, 14.1, '2025-06-08 09:00:00', 10),
(default, 15, '2025-06-08 10:00:00', 10),
(default, 14.2, '2025-06-08 11:00:00', 10),
(default, 13, '2025-06-08 12:00:00', 10),
(default, 14, '2025-06-08 13:00:00', 10),
(default, 13, '2025-06-08 14:00:00', 10),
(default, 14.6, '2025-06-08 15:00:00', 10),
(default, 13, '2025-06-08 16:00:00', 10),
(default, 13, '2025-06-08 17:00:00', 10);


