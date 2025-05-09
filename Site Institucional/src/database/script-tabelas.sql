create database capitulo;
use capitulo;

create table usuario (
idUser int primary key auto_increment,
nome varchar(45) not null,
sobrenome varchar(45) not null,
email varchar(45) not null,
senha varchar(45) not null
);

select * from usuario;

create table medida (
	id INT PRIMARY KEY AUTO_INCREMENT,
	dht11_umidade DECIMAL,
	dht11_temperatura DECIMAL,
	luminosidade DECIMAL,
	lm35_temperatura DECIMAL,
	chave TINYINT,
	momento DATETIME,
	fk_aquario INT,
	FOREIGN KEY (fk_aquario) REFERENCES aquario(id)
);


