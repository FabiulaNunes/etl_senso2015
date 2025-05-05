USE db_senso2015;
-- ETL e EDA

-- Mostrar os cinco primeiros registros da tabela dados
SELECT * FROM dados LIMIT 5;

-- Descobrir os dados qualitativos e quantitativos 
describe dados;

-- Como mostrar todos os dados da coluna Anos de Estudo
-- obs: Anos de Estudo, tem espaço, necessariamente vai precisar alterar o nome da table.
ALTER TABLE dados CHANGE COLUMN Anos de Estudo Anos_de_estudo longtext;
DESCRIBE dados;
SELECT Anos_de_estudo FROM dados;

-- Mostrar a coluna Ano_de_estudo, porém, apenas valores únicos (elimina duplicatas)
SELECT DISTINCT Anos_de_estudo FROM dados;

-- Mostrar os dados em ordem crescente (ordenado)
SELECT DISTINCT Anos_de_estudo
FROM dados
ORDER BY CAST(Anos_de_estudo AS UNSIGNED);

SELECT * FROM dados ORDER BY Anos_de_estudo ASC;

-- Subquery
-- Mostrar os últimos cinco registros e os ordena em ordem crescente por ID
ALTER TABLE dados
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;
SELECT id, Anos_de_estudo
FROM (
	SELECT id, Anos_de_estudo
    FROM dados
    ORDER BY id DESC
    LIMIT 5
) AS subquery
ORDER BY id ASC;

SELECT COUNT(*) FROM dados;

-- Verficar os campos que possuem códigos:
-- UF= GO, UF= código
DESCRIBE dados;
SELECT UF, Sexo, Cor FROM dados;

-- Mostrar a idade mínima e a idade máxima
SELECT MIN(idade) AS idade_minima, MAX(idade) AS idade_maxima FROM dados;

-- Calcular a média dos seguintes campos:
-- Idade, Anos_de_estudo, Renda
SELECT 
    AVG(Idade) AS Media_Idade,
    AVG(Anos_de_estudo) AS Media_Anos_de_estudo,
    AVG(Renda) AS Media_Renda
FROM dados;

-- Quantos entrevistados na minha amostra possuem idade inferior a 18 anos ?
SELECT idade FROM dados;
-- Filtros
SELECT id, idade FROM dados WHERE idade>=18 LIMIT 5;
SELECT id, idade FROM dados WHERE idade<18 LIMIT 10;
SELECT COUNT(id) AS total_menores FROM dados WHERE idade<18;
SELECT COUNT(id) AS total_maiores FROM dados WHERE idade>=18;
SELECT COUNT(id) AS total_maiores FROM dados WHERE idade>60;

-- Criar um procedure que mostre o valor de uma variável
-- Idade = (atribuição)
-- 18
-- Mostrar a variável 
DELIMITER //
CREATE PROCEDURE MostrarIdade()
BEGIN
    DECLARE idade INT;
    SET idade = 18;
    SELECT idade AS 'Idade';
END //

DELIMITER ;

CALL MostrarIdade();

-- Se a idade for maior que 18?
DELIMITER //
CREATE PROCEDURE VerificarMaiorIdade()
BEGIN
    DECLARE idade INT;
    SET idade = 18;
    IF idade >=18 THEN
		SELECT 'maior que 18' AS 'Mensagem';
	ELSE 
		SELECT 'menor que 18' AS 'Mensagem';
	END IF;
END //

DELIMITER ;

CALL VerificarMaiorIdade();

SHOW TABLES;

-- RENAME TABLE dados - dados TO dados; (comando para alterar o nome da tabela)


DELIMITER // -- Delimitador (explica qual delimitador escolher, tem // # ;)
CREATE PROCEDURE AloMundoSenai()
BEGIN
	SELECT 'Alô Mundo!' AS Mensagem;
END //
DELIMITER ;

CALL AloMundoSenai();

-- Somar dois números
DELIMITER //
CREATE PROCEDURE SomarNumeros(IN numero1 INT, IN numero2 INT)
BEGIN
    DECLARE soma INT;
    SET soma = numero1 + numero2;
	SELECT soma AS 'Resultado da Soma';
END //

DELIMITER ;

CALL SomarNumeros(10,10);

DELIMITER //

CREATE PROCEDURE SomarIdadeMinMaxIbge()
BEGIN
    DECLARE idade_min INT;
    DECLARE idade_max INT;
    DECLARE soma INT;
-- Obtém a idade mínima e máxima da tabela 'pessoas'
    SELECT MIN(idade) INTO idade_min FROM dados;
    SELECT MAX(idade) INTO idade_max FROM dados;
-- Calcula a soma
	SET soma = idade_min + idade_max;
-- Exibe o resultado
	SELECT soma AS 'Soma da Idade Mínima e Máxima';
END //

DELIMITER ;

CALL SomarIdadeMinMaxIbge();

-- Calcular a média
DELIMITER //
CREATE PROCEDURE CalcularMediaIdade()
BEGIN
    DECLARE media_idade DECIMAL (10,2);
    
    SELECT AVG(idade) INTO media_idade FROM dados;
    
	SELECT ROUND(media_idade,0) AS MediaIdade;
END //

DELIMITER ;

CALL CalcularMediaIdade();

DROP PROCEDURE CalcularMediaIdade;

-- Calcular a média das rendas no banco de dados ( e o mínimo, máximo )
DELIMITER //

CREATE PROCEDURE CalcularMediaRenda()
BEGIN
    DECLARE media_renda DECIMAL (10,2);
    DECLARE maximo DECIMAL;
    DECLARE minimo DECIMAL;
	SELECT AVG(renda) INTO media_renda FROM dados;
    SELECT MAX(renda) INTO maximo FROM dados;
    SELECT MIN(renda) INTO minimo FROM dados;
    SELECT media_renda AS MediRenda, maximo, minimo;
END //

DELIMITER ;

CALL CalcularMediaRenda();

DROP PROCEDURE CalcularMediaRenda;

ALTER TABLE dados
MODIFY renda DECIMAL (10,2);


-- Excluindo valores => 200000 -- 

CALL CalcularMediaRenda();
SELECT MAX(renda) FROM dados;
SELECT MIN(renda) FROM dados;
SELECT renda FROM dados WHERE renda >=100000 AND renda <= 200000 ORDER BY renda ASC;
SELECT renda FROM dados WHERE renda >=1 AND renda <= 50;
SELECT COUNT(*) FROM dados WHERE renda = 0.00;
SELECT COUNT(*) FROM dados WHERE renda = 200000;
SELECT id,renda FROM dados WHERE renda = 200000;
DELETE FROM dados WHERE ID = 28111;
DELETE FROM dados WHERE ID = 43694;
DELETE FROM dados WHERE ID = 56142;
SELECT renda FROM dados;
DESCRIBE dados;








