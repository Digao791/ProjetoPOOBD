-- Criando o Banco de Dados

CREATE DATABASE whack_a_mole;
USE whack_a_mole;

-- Criando Tabelas

CREATE TABLE Mundo(
	id INT NOT NULL AUTO_INCREMENT ,
    Num INT,
    PRIMARY KEY (id)
);

CREATE TABLE Jogador(
	id_Mundo INT AUTO_INCREMENT,
    pontuacao INT,
    PRIMARY KEY (id_Mundo),
    -- Relacionamento 1 x 1
    CONSTRAINT fk1_Mundo
		FOREIGN KEY (id_Mundo)
        REFERENCES Mundo (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE Topeira (
	id INT NOT NULL AUTO_INCREMENT,
    cor CHAR(10) NOT NULL,
    id_MundoTopeira INT,
    -- Relacionamento 1 x N
    PRIMARY KEY (id),
     CONSTRAINT fk2_Mundo
		FOREIGN KEY (id_Mundo)
        REFERENCES Mundo (id)
);

CREATE TABLE Jogador_mata_Topeira (
	id_Jogador INT NOT NULL,
    id_Topeira INT NOT NULL,
    quantidade INT,
	PRIMARY KEY (id_Jogador, id_Topeira),
    -- Relacionamento N x N
    CONSTRAINT fk3_Jogador
		FOREIGN KEY (id_Jogador)
        REFERENCES Jogador (id_Mundo)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,
	CONSTRAINT fk4_Topeira
		FOREIGN KEY (id_Topeira)
        REFERENCES Topeira (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

DELIMITER $$
	DROP FUNCTION IF EXISTS buscar_ultimo_id_Mundo $$
	CREATE FUNCTION buscar_ultimo_id_Mundo ()
		RETURNS INT
		DETERMINISTIC
	BEGIN
		DECLARE ultimo_id INT;
		SET ultimo_id = (SELECT id FROM Mundo ORDER BY id DESC LIMIT 1);
		RETURN ultimo_id;
	END $$
DELIMITER ;

DELIMITER $$
	DROP PROCEDURE IF EXISTS mata_topeiras $$
	CREATE PROCEDURE mata_topeiras (IN nova_quantidade INT, IN tipo_Topeira INT)
		BEGIN
			DECLARE ultimo_id INT;
            SET ultimo_id = (SELECT buscar_ultimo_id_Mundo());
            UPDATE Jogador_mata_Topeira SET quantidade = nova_quantidade
				WHERE id_Jogador = ultimo_id AND id_Topeira = tipo_Topeira;
		END $$
DELIMITER ;


SELECT * FROM Topeira;
SELECT * FROM Jogador;

-- Inserindo valores na Tabela Jogador mata Topeira

INSERT INTO Jogador_mata_Topeira(id_Jogador,id_Topeira,quantidade) VALUES(1,1,5);
INSERT INTO Jogador_mata_Topeira(id_Jogador,id_Topeira,quantidade) VALUES(2,2,3);
INSERT INTO Jogador_mata_Topeira(id_Jogador,id_Topeira,quantidade) VALUES(3,3,3);
INSERT INTO Jogador_mata_Topeira(id_Jogador,id_Topeira,quantidade) VALUES(1,7,2);


SELECT id_Jogador AS "Jogador", Topeira.cor AS "Topeira", quantidade AS "Quantidade" FROM Jogador_mata_Topeira INNER JOIN Topeira
ON Topeira.id = Jogador_mata_Topeira.id_Topeira;









