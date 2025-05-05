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
-- Início do script MySQL

-- Alterando o delimitador para '//' para criar procedimentos armazenados.
DELIMITER //

-- Criação do procedimento armazenado que calcula a média, o máximo e o mínimo da renda.
CREATE PROCEDURE CalcularMediaRenda()
BEGIN
    DECLARE media_renda DECIMAL(10,2);
    DECLARE maximo DECIMAL(10,2);
    DECLARE minimo DECIMAL(10,2);
    
    -- Calcula a média da renda e armazena na variável 'media_renda'.
    SELECT AVG(renda) INTO media_renda FROM dados;
    
    -- Calcula o maior valor de renda e armazena na variável 'maximo'.
    SELECT MAX(renda) INTO maximo FROM dados;
    
    -- Calcula o menor valor de renda e armazena na variável 'minimo'.
    SELECT MIN(renda) INTO minimo FROM dados;
    
    -- Retorna a média, o valor máximo e o valor mínimo da renda.
    SELECT media_renda AS 'MediaRenda', maximo AS 'MaximoRenda', minimo AS 'MinimoRenda';
END //

-- Restaurando o delimitador padrão para ';'.
DELIMITER ;

-- Chamando o procedimento armazenado para executar e mostrar a média, o máximo e o mínimo da renda.
CALL CalcularMediaRenda();

-- Removendo o procedimento armazenado 'CalcularMediaRenda' após sua execução.
DROP PROCEDURE CalcularMediaRenda;

-- Modificando a coluna 'renda' para o tipo DECIMAL(10,2).
ALTER TABLE dados
MODIFY renda DECIMAL(10,2);

-- Comentário indicando a intenção de filtrar/excluir valores de renda maiores ou iguais a 200000.
-- Como não há um procedimento armazenado para isso, vamos usar comandos SQL diretos.

-- Selecionando o maior valor de renda para verificar antes de excluir.
SELECT MAX(renda) FROM dados;

-- Selecionando o menor valor de renda para verificar antes de excluir.
SELECT MIN(renda) FROM dados;

-- Selecionando e ordenando valores de renda entre 100000 e 200000 de forma ascendente.
SELECT renda FROM dados WHERE renda >= 100000 AND renda <= 200000 ORDER BY renda ASC;

-- Selecionando valores de renda entre 1 e 50.
SELECT renda FROM dados WHERE renda >= 1 AND renda <= 50;

-- Contando o número de registros onde a renda é exatamente 0.00.
SELECT COUNT(*) FROM dados WHERE renda = 0.00;

-- Contando o número de registros onde a renda é exatamente 200000.
SELECT COUNT(*) FROM dados WHERE renda = 200000;

-- Selecionando IDs e rendas onde a renda é exatamente 200000.
SELECT id, renda FROM dados WHERE renda = 200000;

-- Excluindo o registro com ID específico de 28111.
DELETE FROM dados WHERE ID = 28111;

-- Excluindo o registro com ID específico de 43694.
DELETE FROM dados WHERE ID = 43694;

-- Excluindo o registro com ID específico de 56142.
DELETE FROM dados WHERE ID = 56142;

-- Selecionando todos os valores de renda após as exclusões.
SELECT renda FROM dados;

-- Descrevendo a tabela 'dados' para verificar a estrutura após as alterações.
DESCRIBE dados;

-- Aqui seria o ponto onde um procedimento ou comando para excluir valores de renda maiores ou iguais a 200000 seria implementado.
-- Como não temos um procedimento para isso, vamos incluir um comando SQL direto para exemplificar.
-- ATENÇÃO: Este comando irá excluir todos os registros onde a renda for maior ou igual a 200000.
-- DELETE FROM dados WHERE renda >= 200000;

-- Se quisermos apenas visualizar os registros que seriam excluídos, usamos o SELECT.
SELECT * FROM dados WHERE renda >= 200000;









