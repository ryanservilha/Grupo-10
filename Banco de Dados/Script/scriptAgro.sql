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
(default, 'Umidade Capacitivo', 'inativo', 1, 1),
(default, 'Umidade Capacitivo', 'inativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'ativo', 1, 1),
(default, 'Umidade Capacitivo', 'inativo', 1, 1);

INSERT INTO funcionario (nome, cpf, email, senha, setor, fkGerente, fkEmpresa, fkCodigo) VALUES
('Carlos Gerente',  '44999999999', 'carlos@empresa.com', 'senha123',  'TI',  NULL, 1, '12125'),
('Ana Engenheira', '44988887777', 'ana@empresa.com',    'senha456', 'Engenharia Agrícola',1, 1, '12125'),
('Bruno Técnico',   '66997776666', 'bruno@empresa.com',  'senha789','Administração', 1,  1, '34345');
