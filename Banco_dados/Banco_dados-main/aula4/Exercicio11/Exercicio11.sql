CREATE DATABASE exercicio11
GO
USE exercicio11
GO
CREATE TABLE plano_de_saude(
codigo								INT						IDENTITY(1234, 1111),
nome								VARCHAR(80)				NOT NULL,
telefone							CHAR(8)					NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE paciente(
CPF									CHAR(11)				NOT NULL,
nome								VARCHAR(150)			NOT NULL,
rua									VARCHAR(100)			NOT NULL,
numero								INT						NOT NULL,
bairro								VARCHAR(30)				NOT NULL,
telefone							CHAR(8)					NOT NULL,
plano								INT						NOT NULL
PRIMARY KEY(CPF)
FOREIGN KEY(plano) REFERENCES plano_de_saude(codigo)
)
GO
CREATE TABLE medico(
codigo								INT						IDENTITY(1, 1),
nome								VARCHAR(150)			NOT NULL,
especialidade						VARCHAR(100)			NOT NULL,
plano								INT						NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(plano) REFERENCES plano_de_saude(codigo)
)
GO
CREATE TABLE consultas(
medico								INT						NOT NULL,
paciente							CHAR(11)				NOT NULL,
dataHora							DATETIME				NOT NULL,
diagnostico							VARCHAR(20)				NOT NULL
PRIMARY KEY(medico, paciente, dataHora)
FOREIGN KEY(medico) REFERENCES medico(codigo),
FOREIGN KEY(paciente) REFERENCES paciente(CPF)
)
GO
INSERT INTO plano_de_saude VALUES
('Amil', '41599856'),
('Sul Am�rica', '45698745'),
('Unimed', '48759836'),
('Bradesco Sa�de', '47265897'),
('Interm�dica', '41415269')
GO
INSERT INTO paciente VALUES
('85987458920', 'Maria Paula', 'R. Volunt�rios da P�tria', 589, 'Santana', '98458741', 2345),
('87452136900', 'Ana Julia', 'R. XV de Novembro', 657, 'Centro', '69857412', 5678),
('23659874100', 'Jo�o Carlos', 'R. Sete de Setembro', 12, 'Rep�blica', '74859632', 1234),
('63259874100', 'Jos� Lima', 'R. Anhaia', 768, 'Barra Funda', '96524156', 2345)
GO
INSERT INTO medico VALUES
('Claudio', 'Cl�nico Geral', 1234),
('Larissa', 'Ortopedista', 2345),
('Juliana', 'Otorrinolaringologista', 4567),
('S�rgio', 'Pediatra', 1234),
('Julio', 'Cl�nico Geral', 4567),
('Samara', 'Cirurgi�o', 1234)
GO
INSERT INTO consultas VALUES
(1, '85987458920', '2021-02-10 10:30:00', 'Gripe'),
(2, '23659874100', '2021-02-10 11:00:00', 'P� Fraturado'),
(4, '85987458920', '2021-02-11 14:00:00', 'Pneumonia'),
(1, '23659874100', '2021-02-11 15:00:00', 'Asma'),
(3, '87452136900', '2021-02-11 16:00:00', 'Sinusite'),
(5, '63259874100', '2021-02-11 17:00:00', 'Rinite'),
(4, '23659874100', '2021-02-11 18:00:00', 'Asma'),
(5, '63259874100', '2021-02-12 10:00:00', 'Rinoplastia')
GO
SELECT * FROM plano_de_saude
SELECT * FROM paciente
SELECT * FROM medico
SELECT * FROM consultas

-- Consultar Nome e especialidade dos m�dicos da Amil				
SELECT
	medico.nome AS [NOME DO MEDICO],
	medico.especialidade AS [ESPECIALIDADE]
FROM medico
INNER JOIN plano_de_saude ON plano_de_saude.codigo = medico.plano
WHERE plano_de_saude.nome LIKE '%Amil%'

-- Consultar Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes						
SELECT
	paciente.nome AS [NOME DO PACIENTE],
	CONCAT(paciente.bairro, ', ', paciente.rua, ', ', paciente.numero) AS [ENDERECO],
	paciente.telefone AS [TELEFONE],
	plano_de_saude.nome AS [PLANO DE SAUDE]
FROM paciente
INNER JOIN plano_de_saude ON plano_de_saude.codigo = paciente.plano

-- Consultar Telefone do Plano de  Sa�de de Ana J�lia				
SELECT
	paciente.telefone AS [TELEFONE],
	plano_de_saude.nome AS [PLANO DE SAUDE]
FROM paciente
INNER JOIN plano_de_saude ON plano_de_saude.codigo = paciente.plano
WHERE paciente.nome LIKE '%Ana Julia%'

-- Consultar Plano de Sa�de que n�o tem pacientes cadastrados				
SELECT 
    plano_de_saude.nome AS [NOME DO PLANO]
FROM plano_de_saude
LEFT OUTER JOIN paciente ON paciente.plano = plano_de_saude.codigo
WHERE paciente.plano IS NULL;

-- Consultar Planos de Sa�de que n�o tem m�dicos cadastrados				
SELECT
	plano_de_saude.nome AS [NOME DO PLANO]
FROM plano_de_saude
LEFT OUTER JOIN medico ON medico.plano = plano_de_saude.codigo
WHERE medico.plano IS NULL

-- Consultar Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas							
SELECT
	FORMAT(consultas.dataHora, 'dd/MM/yyyy HH:MM') AS [Data e Hora],
	medico.nome AS [NOME DO MEDICO],
	paciente.nome AS [NOME DO PACIENTE],
	consultas.diagnostico AS [DIAGNOSTICO]
FROM consultas
INNER JOIN medico ON medico.codigo = consultas.medico
INNER JOIN paciente ON paciente.CPF = consultas.paciente

-- Consultar Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima					
SELECT
	medico.nome AS [NOME DO MEDICO],
	FORMAT(consultas.dataHora, 'dd/MM/yyyy HH:MM') AS [Data e Hora],
	consultas.diagnostico AS [DIAGNOSTICO]
FROM consultas
INNER JOIN medico ON medico.codigo = consultas.medico
INNER JOIN paciente ON paciente.CPF = consultas.paciente
WHERE paciente.nome LIKE '%Jos� Lima%'

-- Consultar Diagn�stico e Quantidade de consultas que aquele diagn�stico foi dado (Coluna deve chamar qtd)						
SELECT
	consultas.diagnostico AS [DIAGNOSTICO],
	COUNT(consultas.diagnostico) AS [qtd]
FROM consultas
GROUP BY consultas.diagnostico

-- Consultar Quantos Planos de Sa�de que n�o tem m�dicos cadastrados					
SELECT
	COUNT(plano_de_saude.nome) AS [qtd]
FROM plano_de_saude
LEFT OUTER JOIN medico ON medico.plano = plano_de_saude.codigo
WHERE medico.plano IS NULL

-- Alterar o nome de Jo�o Carlos para Jo�o Carlos da Silva				
UPDATE paciente
SET nome = 'Jo�o Carlos da Silva'
WHERE nome = 'Jo�o Carlos'
GO
SELECT * FROM paciente

-- Deletar o plano de Sa�de Unimed		
DELETE plano_de_saude
WHERE nome = 'Unimed'
GO
SELECT * FROM plano_de_saude

-- Renomear a coluna Rua da tabela Paciente para Logradouro				
EXEC sp_rename 'paciente.Rua', 'Logradouro', 'COLUMN';
GO
SELECT * FROM paciente

-- Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente										
ALTER TABLE paciente
ADD data_nasc DATE;
GO
UPDATE paciente
SET data_nasc = '1990-04-18'
WHERE nome = 'Maria Paula';
GO
UPDATE paciente
SET data_nasc = '1981-03-25'
WHERE nome = 'Ana Julia';
GO
UPDATE paciente
SET data_nasc = '2004-09-04'
WHERE nome = 'Jo�o Carlos da Silva';
GO
UPDATE paciente
SET data_nasc = '1986-06-18'
WHERE nome = 'Jos� Lima';
GO
SELECT * FROM paciente
