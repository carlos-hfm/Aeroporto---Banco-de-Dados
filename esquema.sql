-- Criação do Banco de Dados

-- Dominios
CREATE DOMAIN tipo_passagem varchar(20) 
	CHECK(VALUE = 'Econômica' OR VALUE = 'Executiva' OR VALUE = 'Primeira Classe'); 

CREATE DOMAIN class_aeroporto varchar(20)
	CHECK(VALUE = 'Nacional' OR VALUE = 'Internacional' OR VALUE = 'Particular');


-- Tabelas
CREATE TABLE Usuario (
	CPF char(11) PRIMARY KEY,
	nome varchar(100) NOT NULL,
	CEP varchar(8) NOT NULL,
	DT_nascimento date CHECK(DT_nascimento < CURRENT_DATE) NOT NULL -- CHECK garante que data de nascimento é anterior a hoje
);

CREATE TABLE Telefone (
	CPF_usuario char(11),
	telefone varchar(11),
	CONSTRAINT pk_tel PRIMARY KEY (CPF_usuario, telefone),
	FOREIGN KEY (CPF_usuario) REFERENCES Usuario(CPF)
		ON DELETE CASCADE
);

CREATE TABLE Voo (
	codigo serial PRIMARY KEY,
	qtd_assentos smallint 
				CHECK(qtd_assentos = 19 OR qtd_assentos = 168 OR qtd_assentos = 410) NOT NULL 
					-- valores desse CHECK são as capacidades máximas de cada tipo de avião
);

CREATE TABLE Passagem (
	codigo_voo integer,
	cadeira smallint,
	valor smallint CHECK(valor > 20) NOT NULL, -- CHECK aqui garante restrição segundo a tabela de metadados
	tipo tipo_passagem NOT NULL, -- dominio
	data_compra date CHECK(data_compra <= CURRENT_DATE) NOT NULL, -- CHECK aqui garante que data da compra foi antes de hoje
	CPF_usuario char(11) NOT NULL,
	CONSTRAINT pk_pass PRIMARY KEY (codigo_voo, cadeira),
	FOREIGN KEY (codigo_voo) REFERENCES Voo(codigo)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (CPF_usuario) REFERENCES Usuario(CPF)
		ON DELETE CASCADE
);


CREATE TABLE Estado (
	nome varchar(30) PRIMARY KEY
);

CREATE TABLE Cidade (
	nome varchar(60),
	estado varchar(30),
	CONSTRAINT pk_cid PRIMARY KEY (nome, estado),
	FOREIGN KEY (estado) REFERENCES Estado(nome)
);



CREATE TABLE Aeroporto (
	codigo char(3) PRIMARY KEY,
	cidade varchar(60) NOT NULL,
	estado varchar(30) NOT NULL,
	classificao class_aeroporto NOT NULL, -- dominio
	FOREIGN KEY (cidade,estado) REFERENCES Cidade(nome,estado)
);

CREATE TABLE Partida (
	codigo_voo integer PRIMARY KEY,
	codigo_aeroporto varchar(3),
	data date,
	hora time,
	FOREIGN KEY (codigo_voo) REFERENCES Voo(codigo),
	FOREIGN KEY (codigo_aeroporto) REFERENCES Aeroporto(codigo)
);

CREATE TABLE Chegada (
	codigo_voo integer PRIMARY KEY,
	codigo_aeroporto varchar(3),
	data date,
	hora time,
	FOREIGN KEY (codigo_voo) REFERENCES Voo(codigo),
	FOREIGN KEY (codigo_aeroporto) REFERENCES Aeroporto(codigo)

);

/*
DROP TABLE Partida;
DROP TABLE Chegada;
DROP TABLE aeroporto;
DROP TABLE cidade;
DROP TABLE estado;
DROP TABLE passagem;
DROP TABLE voo;
DROP TABLE telefone;
DROP TABLE usuario;
*/