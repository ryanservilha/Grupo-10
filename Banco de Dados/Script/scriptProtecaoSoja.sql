-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE protecaoSoja;

-- USANDO O BANCO DE DADOS
USE protecaoSoja;

-- CRIAÇÃO DA TABELA DO CLIENTE
CREATE TABLE enderecoEmpresa (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(100),
    numero VARCHAR(6),
    cidade VARCHAR(45),
    estado CHAR(2),
    pais VARCHAR(45)
);

CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
	razaoSocial VARCHAR(45),
    cnpj CHAR(14),
    emailEmpresa VARCHAR(45),
    nomeUsuario VARCHAR(45),
    senhaEmpresa VARCHAR(45),
    telefone CHAR(11),
    fkEndereco INT UNIQUE,
    CONSTRAINT fkEmpresaEndereco
    FOREIGN KEY (fkEndereco)
    REFERENCES enderecoEmpresa(idEndereco)
);

CREATE TABLE setorFuncionario (
	idSetor INT PRIMARY KEY AUTO_INCREMENT,
    nomeSetor VARCHAR(45)
);

CREATE TABLE funcionarioEmpresa (
	idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    nomeFuncionario VARCHAR(60),
    fkSetor INT,
    fkGerente INT,
    CONSTRAINT fkSetorFuncionario 
    FOREIGN KEY (fkSetor) 
    REFERENCES setorFuncionario(idSetor),
    CONSTRAINT fkFuncionarioGerente
    FOREIGN KEY (fkGerente)
    REFERENCES funcionarioEmpresa(idFuncionario)
);

CREATE TABLE sensorEmpresa (
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
    nomeSensor VARCHAR(20),
    statusSensor VARCHAR(7),
    localidadeSensor VARCHAR(45),
    fkEmpresa INT,
    fkResponsavelSensor INT,
    CONSTRAINT chkStatusSensor	
    CHECK (statusSensor in ('ativo', 'inativo')),
    CONSTRAINT fkSensorEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES empresa(idEmpresa),
    CONSTRAINT fkSensorResponsavel
    FOREIGN KEY (fkResponsavelSensor)
    REFERENCES funcionarioEmpresa(idFuncionario)
);

CREATE TABLE dadoSensor (
	idDadoSensor INT PRIMARY KEY AUTO_INCREMENT,
	dadoSensor DECIMAL(3,1),
    dataHoraEmissao TIMESTAMP,
    fkSensor INT,
    CONSTRAINT fkSensorDado
    FOREIGN KEY (fkSensor)
    REFERENCES sensorEmpresa(idSensor)
);


