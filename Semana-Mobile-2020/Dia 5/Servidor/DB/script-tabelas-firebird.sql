CREATE TABLE TAB_USUARIO (
    COD_USUARIO VARCHAR(50) NOT NULL PRIMARY KEY,
    NOME       VARCHAR(100)
);

/*-------------------------------------*/

CREATE TABLE TAB_PRODUTO_CATEGORIA (
    ID_CATEGORIA INT NOT NULL PRIMARY KEY,
    DESCRICAO    VARCHAR(100),
    ICONE        BLOB
);

create generator gen_categoria_id;

CREATE TRIGGER TR_CATEGORIA FOR TAB_PRODUTO_CATEGORIA
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    new.ID_CATEGORIA =gen_id(gen_categoria_id, 1);
END

/*-------------------------------------*/

CREATE TABLE TAB_PRODUTO (
    ID_PRODUTO INT NOT NULL PRIMARY KEY,
    DESCRICAO    VARCHAR(100),
    PRECO        DECIMAL(12,2),
    ID_CATEGORIA INT
);

create generator gen_produto_id;

CREATE TRIGGER TR_PRODUTO FOR TAB_PRODUTO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    new.ID_PRODUTO =gen_id(gen_produto_id, 1);
END

/*-------------------------------------*/

CREATE TABLE TAB_COMANDA (
    ID_COMANDA   VARCHAR(50) NOT NULL PRIMARY KEY,
    STATUS       CHAR(1),
    DT_ABERTURA  TIMESTAMP
);


/*-------------------------------------*/

CREATE TABLE TAB_COMANDA_CONSUMO (
    ID_CONSUMO   INT NOT NULL PRIMARY KEY,
    ID_COMANDA   VARCHAR(50),
    ID_PRODUTO   INT,
    QTD          INT,
    VALOR_TOTAL  DECIMAL(12,2),
    OBS          VARCHAR(100)
);

create generator gen_consumo_id;

CREATE TRIGGER TR_CONSUMO FOR TAB_COMANDA_CONSUMO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    new.ID_CONSUMO =gen_id(gen_consumo_id, 1);
END
