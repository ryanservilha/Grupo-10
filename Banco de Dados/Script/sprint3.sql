create database sprint3;
use sprint3;

-- relacionamento n n 

create table aluno (
idAluno int primary key auto_increment,
nome varchar(45) not null,
email varchar(45) unique
);

insert into aluno (nome, email) values
('Vager', 'vager@gmail.com'),
('George', 'george@gmail.com'),
('Julia', 'julia@gmail.com');

select * from aluno;

create table curso (
idCurso int primary key auto_increment,
nome varchar(45),
cargaHoraria int) auto_increment = 60;

insert into curso (nome, cargaHoraria) values
('Ingles', 100),
('Espanhol', 120),
('Mandarim', 220);

create table matricula (
idMatricula int,
fkAluno int,
fkCurso int,
constraint pkComposta
primary key (idMatricula, fkAluno, fkCurso),
nota decimal(4,2),
dtMatricula date,
constraint fkAlunoMat foreign key(fkAluno)
references aluno(idAluno),
foreign key (fkCurso)
references curso(idCurso)
);

insert into matricula values
(1, 1, 60, 9.5, '2024-01-01'),
(2, 1, 61, null, '2025-01-01'),
(3, 2, 61, 4.5, '2024-05-05'),
(4, 3, 60, null, '2025-06-09');

select a.nome as Aluno,
	c.nome as Curso,
    m.nota as Nota,
    ifnull(nota, 'Em Andamento') statusCurso
	from aluno as a join matricula as m
	on idAluno = fkAluno
    right join curso as c
    on idCurso = fkCurso
    where fkAluno is null;
    
-- Funçoes matemáticas
-- soma

select sum(nota) as Soma from aluno join matricula
	on idAluno = fkAluno; 
    
-- Media - average

select avg(nota) as Média from matricula;

select nota*0.6 from matricula;

-- round

select round(avg(nota),0) as média from matricula;

-- count 

select count(nota) as Quantidade from matricula;