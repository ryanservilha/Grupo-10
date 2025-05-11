-- criação do banco de dados
-- CREATE DATABASE protecaoSoja;

-- usando o banco de dados
USE protecaoSoja;

-- criação da tabela enderecoEmpresa

CREATE TABLE enderecoEmpresa (
idEndereco INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
logradouro VARCHAR(100) NOT NULL,
numero VARCHAR(6) NOT NULL,
cidade VARCHAR(45) NOT NULL,
estado CHAR(2) NOT NULL,
pais VARCHAR(45) NOT NULL
);

-- insert para enderecoEmpresa

INSERT INTO enderecoEmpresa (logradouro, numero, cidade, estado, pais) VALUES
('Rua das Lavouras', '123', 'Londrina', 'PR', 'Brasil'),
('Av. Soja Forte', '456', 'Sorriso', 'MT', 'Brasil');

-- criação da tabela empresa

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
razaoSocial VARCHAR(45) NOT NULL,
cnpj CHAR(14) NOT NULL,
emailEmpresa VARCHAR(45) NOT NULL,
nomeUsuario VARCHAR(45) NOT NULL,
senhaEmpresa VARCHAR(45) NOT NULL,
telefone CHAR(11) NOT NULL,
fkEndereco INT UNIQUE NOT NULL,
CONSTRAINT fkEmpresaEndereco 
FOREIGN KEY (fkEndereco)
REFERENCES enderecoEmpresa(idEndereco)
);

-- insert para empresa

INSERT INTO empresa (razaoSocial, cnpj, emailEmpresa, nomeUsuario, senhaEmpresa, telefone, fkEndereco) VALUES
('AgroSoja LTDA', '12345678000199', 'contato@agrosoja.com', 'agrosoja_user', 'senha123', '44999999999', 1),
('SojaMax SA', '98765432000155', 'suporte@sojamax.com', 'sojamax_user', 'senha456', '66988888888', 2);

-- criação da tabela setorFuncionario

CREATE TABLE setorFuncionario (
idSetor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nomeSetor VARCHAR(45) NOT NULL
);

-- insert para setorFuncionario
INSERT INTO setorFuncionario (nomeSetor) VALUES
('TI'),
('Engenharia Agrícola'),
('Administração');

-- criação da tabela funcionarioEmpresa

CREATE TABLE funcionarioEmpresa (
idFuncionario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nomeFuncionario VARCHAR(60) NOT NULL,
fkSetor INT NOT NULL,
fkGerente INT NOT NULL,
CONSTRAINT fkSetorFuncionario 
FOREIGN KEY (fkSetor) 
REFERENCES setorFuncionario(idSetor),
CONSTRAINT fkFuncionarioGerente
FOREIGN KEY (fkGerente)
REFERENCES funcionarioEmpresa(idFuncionario)
);

-- insert para funcionarioEmpresa (gerente)

INSERT INTO funcionarioEmpresa (nomeFuncionario, fkSetor, fkGerente) VALUES
('Carlos Gerente', 3, 1); -- o próprio como gerente para evitar erro de chave estrangeira

-- inserts para funcionarioEmpresa (outros funcionários)

INSERT INTO funcionarioEmpresa (nomeFuncionario, fkSetor, fkGerente) VALUES
('Ana Engenheira', 2, 1),
('Bruno Técnico', 1, 1);

-- criação da tabela sensorEmpresa
CREATE TABLE sensorEmpresa (
idSensor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nomeSensor VARCHAR(20) NOT NULL,
statusSensor VARCHAR(7) NOT NULL,
fkResponsavelSensor INT NOT NULL,
CONSTRAINT chkStatusSensor	
CHECK (statusSensor IN ('ativo', 'inativo')),
CONSTRAINT fkSensorResponsavel
FOREIGN KEY (fkResponsavelSensor)
REFERENCES funcionarioEmpresa(idFuncionario)
);

-- inserts para sensorEmpresa

INSERT INTO sensorEmpresa (nomeSensor, statusSensor, fkResponsavelSensor) VALUES
('SensorUmidade', 'ativo', 2),
('SensorPH', 'inativo', 3),
('SensorTemperatura', 'ativo', 2);

-- criação da tabela dadoSensor

CREATE TABLE dadoSensor (
idDadoSensor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
dadoSensor DECIMAL(3,1) NOT NULL,
dataHoraEmissao TIMESTAMP NOT NULL,
fkSensor INT NOT NULL,
CONSTRAINT fkSensorDado
FOREIGN KEY (fkSensor)
REFERENCES sensorEmpresa(idSensor)
);

-- inserts para dadoSensor

INSERT INTO dadoSensor (dadoSensor, dataHoraEmissao, fkSensor) VALUES
(23.4, NOW(), 1),
(5.8, NOW(), 2),
(30.1, NOW(), 3);

-- criação da tabela localidadeSensor

CREATE TABLE localidadeSensor (
idLocalidade INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
terreno VARCHAR(45) NOT NULL, 
fkEmpresa INT NOT NULL,
CONSTRAINT fkEmpresaLocalidade 
FOREIGN KEY (fkEmpresa)
REFERENCES empresa(idEmpresa)
);

-- inserts para localidadeSensor

INSERT INTO localidadeSensor (terreno, fkEmpresa) VALUES
('Fazenda Rio Verde', 1),
('Fazenda Sol Nascente', 2);

-- insert para medidaSensor
CREATE TABLE medidaSensor (
idMedida int primary key auto_increment,
sensor_analogico decimal (4,2),
dataAtual datetime default current_timestamp
);

select * from  medidaSensor;
 