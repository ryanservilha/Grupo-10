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
  fkEndereco INT UNIQUE NOT NULL,
  CONSTRAINT fkEmpresaEndereco 
    FOREIGN KEY (fkEndereco)
    REFERENCES endereco(idEndereco)
);

-- inserts para empresa
INSERT INTO empresa (razaoSocial, cnpj, fkEndereco) VALUES
('AgroSoja LTDA', '12345678000199', 1),
('SojaMax SA', '98765432000155', 2);

-- criação da tabela funcionario
CREATE TABLE funcionario (
  idFuncionario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  nome VARCHAR(60) NOT NULL,
  telefone CHAR(11) NOT NULL,
  senha VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  setor VARCHAR(45) NOT NULL,
  fkGerente INT,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkFuncionarioGerente
    FOREIGN KEY (fkGerente)
    REFERENCES funcionario(idFuncionario),
  CONSTRAINT fkFuncionarioEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES empresa(idEmpresa)
);

-- inserts para funcionario
INSERT INTO funcionario (nome, telefone, senha, email, setor, fkGerente, fkEmpresa) VALUES
('Carlos Gerente', '44999999999', 'senha123', 'carlos@empresa.com', 'TI', NULL, 1),
('Ana Engenheira', '44988887777', 'senha456', 'ana@empresa.com', 'Engenharia Agrícola', 1, 1),
('Bruno Técnico', '66997776666', 'senha789', 'bruno@empresa.com', 'Administração', 1, 1);

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

-- inserts para medida
INSERT INTO medida (dado, fkSensor) VALUES
(12.5, 1),
(13.7, 2),
(16.0, 3),
(14.2, 1),
(17.1, 2);

-- select nos dados inseridos pela API; 

SELECT * FROM medida;

-- select para capturar informações da empresa

SELECT 
  e.razaoSocial AS 'Razão Social',
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
JOIN sensor AS s ON s.fkEmpresa = e.idEmpresa
JOIN localidade AS l ON s.fkLocalidade = l.idLocalidade;



-- select para trazer os dados dos sensores que possuem umidade inadequada


SELECT 
  s.nome AS 'Sensor',
  CONCAT(m.dado, '%') AS 'Taxa de Umidade Obtida',
  m.dataHoraEmissao AS 'Data da Emissão',
  l.terreno AS 'Localidade'
FROM sensor AS s
JOIN medida AS m ON m.fkSensor = s.idSensor
JOIN localidade AS l ON s.fkLocalidade = l.idLocalidade
WHERE m.dado > 15 OR m.dado < 13;



-- select com todas as tabelas
SELECT 
  e.razaoSocial AS 'Empresa',
  e.cnpj AS 'CNPJ',
  en.cidade AS 'Cidade',
  en.estado AS 'Estado',
  l.terreno AS 'Terreno',
  f.nome AS 'Funcionário',
  f.setor AS 'Setor',
  se.nome AS 'Sensor',
  se.status AS 'Status do Sensor',
  m.dado AS 'Valor da Medida',
  m.dataHoraEmissao AS 'Data'
FROM empresa AS e
JOIN endereco AS en ON e.fkEndereco = en.idEndereco
JOIN funcionario AS f ON f.fkEmpresa = e.idEmpresa
JOIN sensor AS se ON se.fkEmpresa = e.idEmpresa
JOIN localidade AS l ON se.fkLocalidade = l.idLocalidade
JOIN medida AS m ON m.fkSensor = se.idSensor
ORDER BY m.dataHoraEmissao DESC;





-- KPI Menor Umidade
select min(m.dado) AS 'Menor Taxa de Umidade Registrada', m.dataHoraEmissao AS 'Hora', l.idLocalidade AS 'Terreno' 
from medida as m
join sensor as s
on m.fkSensor = s.idSensor
join localidade as l
ON s.fkLocalidade = l.idLocalidade	
group by dataHoraEmissao, idLocalidade
limit 1;

-- KPI Maior umidade
select max(m.dado) AS 'Menor Taxa de Umidade Registrada', m.dataHoraEmissao AS 'Hora', l.idLocalidade AS 'Terreno' 
from medida as m
join sensor as s
on m.fkSensor = s.idSensor
join localidade as l
ON s.fkLocalidade = l.idLocalidade	
group by dataHoraEmissao, idLocalidade
limit 1;


-- alerta de umidades acima de 15 e abaixo de 13
Select
	l.idlocalidade,
    s.nome as NomeSensor,
    m.dado,
    m.DataHoraEmissao 
    from medida m
    join sensor s on m.fkSensor = s.idSensor
    join localidade l on s.fkLocalidade = l.idlocalidade where m.dado > 15 or m.dado < 13;
    
    
    
	-- Select para contar sensores ativos
    select count(status) as 'Sensores Ativos' from sensor where status = 'ativo';
    
    select m.dado AS 'Variedade de umidade ao longo do dia', m.dataHoraEmissao AS 'Hora', l.idLocalidade AS 'Terreno' 
from medida as m
join sensor as s	
on m.fkSensor = s.idSensor
join localidade as l
ON s.fkLocalidade = l.idLocalidade;
    
SELECT
    m.dado AS 'Umidade',
    m.dataHoraEmissao AS 'Hora da Medição',
    l.idlocalidade AS 'Terreno'
FROM
    medida AS m
JOIN
    sensor AS s ON m.fkSensor = s.idSensor
JOIN
    localidade AS l ON s.fkLocalidade = l.idLocalidade
ORDER BY
    l.idLocalidade, m.dataHoraEmissao;
    