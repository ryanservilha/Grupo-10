-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE protecaoSoja;

-- USANDO O BANCO DE DADOS
USE protecaoSoja;

-- CRIAÇÃO DA TABELA DO CLIENTE

CREATE TABLE enderecoEmpresa (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(6) NOT NULL,
    cidade VARCHAR(45) NOT NULL,
    estado CHAR(2) NOT NULL,
    pais VARCHAR(45) NOT NULL
);
-- CRIAÇÂO DA TABELA EMPRESA 

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
-- CRIAÇÃO DA TABELA SETOR FUNCIONARIO 

CREATE TABLE setorFuncionario (
	idSetor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nomeSetor VARCHAR(45) NOT NULL
);
-- CRIAÇÃO DA TABELA FUNCIONARIO EMPRESA 

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

-- CRIAÇÃO DA TABELA SENSOR EMPRESA

CREATE TABLE sensorEmpresa (
	idSensor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nomeSensor VARCHAR(20) NOT NULL,
    statusSensor VARCHAR(7) NOT NULL,
    localidadeSensor VARCHAR(45) NOT NULL,
    fkEmpresa INT NOT NULL,
    fkResponsavelSensor INT NOT NULL,
    CONSTRAINT chkStatusSensor	
    CHECK (statusSensor in ('ativo', 'inativo')),
    CONSTRAINT fkSensorEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES empresa(idEmpresa),
    CONSTRAINT fkSensorResponsavel
    FOREIGN KEY (fkResponsavelSensor)
    REFERENCES funcionarioEmpresa(idFuncionario)
);

-- CRIAÇÃO DA TABELA DADO SENSOR 

CREATE TABLE dadoSensor (
	idDadoSensor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	dadoSensor DECIMAL(3,1) NOT NULL,
    dataHoraEmissao TIMESTAMP NOT NULL,
    fkSensor INT NOT NULL,
    CONSTRAINT fkSensorDado
    FOREIGN KEY (fkSensor)
    REFERENCES sensorEmpresa(idSensor)
);


