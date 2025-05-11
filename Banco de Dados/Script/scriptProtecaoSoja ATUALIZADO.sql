-- criação do banco de dados

CREATE DATABASE protecaoSoja;

-- usando o banco de dados

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

-- insert para endereco

INSERT INTO endereco (logradouro, numero, cidade, estado, pais) VALUES
('Rua das Lavouras', '123', 'Londrina', 'PR', 'Brasil'),
('Av. Soja Forte', '456', 'Sorriso', 'MT', 'Brasil');

-- criação da tabela empresa

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
razaoSocial VARCHAR(45) NOT NULL,
cnpj CHAR(14) NOT NULL,
fkEndereco INT UNIQUE NOT NULL
CONSTRAINT fkEmpresaEndereco 
FOREIGN KEY (fkEndereco)
REFERENCES endereco(idEndereco)
);

-- insert para empresa

INSERT INTO empresa (razaoSocial, cnpj, fkEndereco) VALUES
('AgroSoja LTDA', '12345678000199', 1),
('SojaMax SA', '98765432000155',  2);

-- criação da tabela setor

CREATE TABLE setor (
idSetor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nome VARCHAR(45) NOT NULL
);

-- insert para setor
INSERT INTO setor (nome) VALUES
('TI'),
('Engenharia Agrícola'),
('Administração');

-- criação da tabela funcionario

CREATE TABLE funcionario (
idFuncionario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nome VARCHAR(60) NOT NULL,
telefone CHAR(11) NOT NULL,
senha VARCHAR(45) NOT NULL,
email VARCHAR(45) NOT NULL,
fkGerente INT,
fkEmpresa INT NOT NULL,  
fkSetor INT NOT NULL,
CONSTRAINT fkSetorFuncionario 
FOREIGN KEY (fkSetor) 
REFERENCES setor(idSetor),
CONSTRAINT fkFuncionarioGerente
FOREIGN KEY (fkGerente)
REFERENCES funcionario(idFuncionario),
CONSTRAINT fkFuncionarioEmpresa
FOREIGN KEY (fkEmpresa)
REFERENCES empresa(idEmpresa)
);

-- inserts para funcionario

INSERT INTO funcionario (nome, telefone, senha, email, fkGerente, fkEmpresa, fkSetor) VALUES
('Carlos Gerente', '44999999999', 'senha123', 'carlos@empresa.com', NULL, 1, 3);

INSERT INTO funcionario (nome, telefone, senha, email, fkGerente, fkEmpresa, fkSetor) VALUES
('Ana Engenheira', '44988887777', 'senha456', 'ana@empresa.com', 1, 1, 2),
('Bruno Técnico', '66997776666', 'senha789', 'bruno@empresa.com', 1, 2, 1);

-- criação da tabela localidade

CREATE TABLE localidade (
idLocalidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
terreno VARCHAR(45) NOT NULL, 
coordenadas VARCHAR(45) NOT NULL UNIQUE,
fkSensor INT NOT NULL
CONSTRAINT fkSensorEmpresa 
FOREIGN KEY (fkSensor)
REFERENCES sensor(idSensor)
);

-- inserts para localidade

INSERT INTO localidade (terreno, coordenadas, fkSensor) VALUES
('Fazenda Rio Verde', '23S51W', 1),
('Fazenda Sol Nascente', '12S55W', 2);

-- criação da tabela sensor

CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nome VARCHAR(20) NOT NULL,
status VARCHAR(7) NOT NULL,
CONSTRAINT chkStatusSensor	
CHECK (statusSensor IN ('ativo', 'inativo'))
);

-- inserts para sensor

INSERT INTO sensor (nome, status) VALUES
('SensorUmidade', 'ativo'),
('SensorPH', 'inativo'),
('SensorTemperatura', 'ativo');

-- criação da tabela medida

CREATE TABLE medida (
idMedida INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
dado DECIMAL(3,1) NOT NULL,
dataHoraEmissao  DATETIME DEFAULT CURRENT_TIMESTAMP,
fkSensor INT NOT NULL,
CONSTRAINT fkSensorDado
FOREIGN KEY (fkSensor)
REFERENCES sensor(idSensor)
);

-- select nos dados inseridos pela API; 

SELECT * FROM medida;

-- select para capturar informações da empresa

SELECT e.razaoSocial AS 'Razão Social',
  e.cnpj AS 'CNPJ',
  CONCAT(en.logradouro, ', ',
         en.numero, ', ',
         en.cidade, ' - ',
         en.estado, ', ',
         en.pais) AS 'Endereço'
FROM empresa AS e
JOIN endereco AS en ON e.fkEndereco = en.idEndereco;

-- select para listar os funcionários da empresa e os sensores

SELECT 
  e.razaoSocial AS 'Razão Social',
  f.nome AS 'Funcionário',
  s.nome AS 'Sensor',
  l.terreno AS 'Localidade do Sensor',
  s.status AS 'Status do Sensor'
FROM empresa AS e
JOIN funcionario AS f ON f.fkEmpresa = e.idEmpresa
JOIN localidade AS l ON l.fkSensor IS NOT NULL
JOIN sensor AS s ON s.idSensor = l.fkSensor;


-- select para trazer os dados dos sensores que possuem umidade inadequada

SELECT s.nome AS 'Sensor',
  CONCAT(m.dado, '%') AS 'Taxa de Umidade Obtida',
  m.dataHoraEmissao AS 'Data da Emissão',
  l.terreno AS 'Localidade'
FROM sensor AS s
JOIN medida AS m ON m.fkSensor = s.idSensor
JOIN localidade AS l ON l.fkSensor = s.idSensor
WHERE m.dado > 15 OR m.dado < 13;

-- select com todas as tabelas

SELECT 
  e.razaoSocial AS 'Empresa',
  e.cnpj AS 'CNPJ',
  en.cidade AS 'Cidade',
  en.estado AS 'Estado',
  l.terreno AS 'Terreno',
  f.nome AS 'Funcionário',
  st.nome AS 'Setor',
  se.nome AS 'Sensor',
  se.status AS 'Status do Sensor',
  m.dado AS 'Valor da Medida',
  m.dataHoraEmissao AS 'Data'
FROM empresa AS e
JOIN endereco AS en ON e.fkEndereco = en.idEndereco
JOIN funcionario AS f ON f.fkEmpresa = e.idEmpresa
JOIN setor AS st ON f.fkSetor = st.idSetor
JOIN localidade AS l ON l.fkSensor IS NOT NULL
JOIN sensor AS se ON se.idSensor = l.fkSensor
JOIN medida AS m ON m.fkSensor = se.idSensor
ORDER BY m.dataHoraEmissao DESC;