create database meu_mercado 
default character set utf8
default collate utf8_general_ci;

/*-------------------------------------------------------------*/

create table usuario(
	id_usuario int not null auto_increment,
	nome varchar(100),
    email varchar(100),
    senha varchar(50),
    endereco varchar(100),
    bairro varchar(50),
    cidade varchar(50),
    uf varchar(2),
    cep varchar(10),
    dt_cadastro datetime,
    
    primary key(id_usuario)
) default charset = utf8;


create table mercado(
	id_mercado int not null auto_increment,
	nome varchar(100),    
    endereco varchar(100),
    bairro varchar(50),
    cidade varchar(50),
    uf varchar(2),
    cep varchar(10),
    dt_cadastro datetime,
    vl_entrega decimal(5, 2),
    vl_compra_min decimal(9, 2), 
    ind_entrega char(1), /* se mercado faz entrega */
    ind_retira char(1), /* se permite retirar na loja */
    
    primary key(id_mercado)
) default charset = utf8;

create table produto_categoria(
	id_categoria int not null auto_increment,
    descricao varchar(100),
    ordem tinyint,
    	
    primary key(id_categoria)
) default charset = utf8;

create table produto(
	id_produto int not null auto_increment,
    id_categoria int not null,
	nome varchar(100),    
    descricao varchar(1000),
    unidade varchar(20),    
    preco decimal(9, 2),
    url_foto varchar(1000),
    id_mercado int not null,    
    	
    primary key(id_produto),
    foreign key(id_mercado) references mercado(id_mercado),
    foreign key(id_categoria) references produto_categoria(id_categoria)
) default charset = utf8;


create table pedido(
	id_pedido int not null auto_increment,
    id_mercado int not null,
    id_usuario int not null,	    
    dt_pedido datetime,
    vl_subtotal decimal(9,2),
    vl_entrega decimal(5, 2),
    vl_total decimal(9,2),
    
    endereco varchar(100),
    bairro varchar(50),
    cidade varchar(50),
    uf varchar(2),
    cep varchar(10),
        
    primary key(id_pedido),
    foreign key(id_mercado) references mercado(id_mercado),
    foreign key(id_usuario) references usuario(id_usuario)
) default charset = utf8;

create table pedido_item(
	id_item int not null auto_increment,
    id_pedido int not null,
    id_produto int not null,
    qtd decimal(9,3),
    vl_unitario decimal(9,2),
    vl_total decimal(9,2),
    
    primary key(id_item),
    foreign key(id_pedido) references pedido(id_pedido),
    foreign key(id_produto) references produto(id_produto)
) default charset = utf8;


/*-------------------------------------------------------------*/

insert into usuario(nome, email, senha, endereco, bairro, cidade, uf, cep, dt_cadastro)
values('Heber Stein Mazutti', 'heber@teste.com.br', '12345', 'Av Paulista, 1500', 'Bela Vista', 'São Paulo', 'SP', '03015-500', current_timestamp());

insert into mercado(nome, endereco, bairro, cidade, uf, cep, dt_cadastro, vl_entrega, vl_compra_min)
values('Pão de Açúcar', 'Av. Interlagos, 850', 'Interlagos', 'São Paulo', 'SP', '05410-010', current_timestamp(), 8.50, 30);

insert into produto_categoria(descricao, ordem) values('Alimentos', 1);
insert into produto_categoria(descricao, ordem) values('Bebidas', 2);
insert into produto_categoria(descricao, ordem) values('Limpeza', 3);
insert into produto_categoria(descricao, ordem) values('Petshop', 4);
insert into produto_categoria(descricao, ordem) values('Papelaria', 5);
insert into produto_categoria(descricao, ordem) values('Brinquedos', 6);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(1, 'Café Pilão Torrado e Moído', 'Café Pilão torrado e moído embalado a vacuo', '250g', 9.75,  
'https://static.paodeacucar.com/img/uploads/1/671/669671x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(1, 'Café 3 Corações Torrado e Moído', 'Café 3 Corações torrado e moído embalado a vacuo', '500g', 18.99,  
'https://static.paodeacucar.com/img/uploads/1/2/656002x200x200.png', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(1, 'Creme de Leite NESTLÉ', 'Delicioso Creme de Leite em caixinha, rico em cremosidade, sabor e consistência.', '200g', 4.25,  
'https://static.paodeacucar.com/img/uploads/1/696/19544696x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(1, 'Atum Sólido Gomes da Costa', 'Atum Sólido Gomes da Costa óleo', '120g', 9.49,  
'https://static.paodeacucar.com/img/uploads/1/591/19918591x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(1, 'Arroz Agulhinha Tipo 1 Camil', 'Pacote de arroz agulhinha tipo 1 Camil', '5kg', 23.99,  
'https://static.paodeacucar.com/img/uploads/1/779/529779x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(1, 'Lasanha de Calabresa Seara', 'A Lasanha de Calabresa Seara tem sabor marcante pois é preparada com Linguiça Calabresa Seara', '600g', 11.99,  
'https://static.paodeacucar.com/img/uploads/1/104/693104x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(2, 'Cerveja Heineken Lata', 'O processo de fermentação da Heineken, a exclusiva Levedura A é responsável pelo sabor característico e bem equilibrado, com notas frutadas sutis.', 
'350ml', 4.80,  'https://static.paodeacucar.com/img/uploads/1/623/17634623x200x200.png', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(2, 'Coca-Cola sem açúcar 2L', 'Refrigerante Coca-Cola Zero embalagem de 2L', 
'2L', 8.99,  'https://static.paodeacucar.com/img/uploads/1/556/19931556x200x200.png', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(2, 'Guaraná Antarctica Garrafa 1.5L', 'Refrigerante guaraná Antarctica garrafa 1.5L', 
'1.5L', 5.19,  'https://static.paodeacucar.com/img/uploads/1/550/16774550x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(2, 'Água tônica SCHWEPPES lata', 'Água tônica SCHWEPPES original lata com 350ml', 
'350ml', 2.79,  'https://static.paodeacucar.com/img/uploads/1/677/11758677x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(2, 'H2OH limão garrafa 500ml', 'Refrigerante H2OH limão - Garrafa de 500ML', 
'500ml', 3.09,  'https://static.paodeacucar.com/img/uploads/1/454/19512454x200x200.jpg', 1);


insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(3, 'Sabão em Pó Omo Lavagem Perfeita', 'Sabão em Pó Omo Lavagem Perfeita 2.2kg', 
'2.2Kg', 33.79,  'https://static.paodeacucar.com/img/uploads/1/478/18508478x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(3, 'Lava-Roupas concentrado primavera Tixan Ypê', 'Lava-Roupas Pó Concentrado Primavera Tixan Ypê Caixa com 1.6kg', 
'1.6Kg', 24.49,  'https://static.paodeacucar.com/img/uploads/1/577/22316577x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(3, 'Lava-Roupas em Pó Brilhante Limpeza Total', 'Lava-Roupas em Pó Roupas Brancas e Coloridas Brilhante Limpeza Total', 
'1.6Kg', 12.70,  'https://static.paodeacucar.com/img/uploads/1/780/13320780x200x200.jpg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(4, 'Ração Úmida Whiskas para Gatos Adultos ', 'Ração Úmida Whiskas Lata Carne ao Molho para Gatos Adultos', 
'290g', 9.29,  'https://static.paodeacucar.com/img/uploads/1/62/22159062x200x200.png', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(4, 'Ração Royal Canin Cães', 'Ração Royal Canin Cães Mini Adulto 8+ 2,5kg', 
'7.5Kg', 118.00,  'https://static.paodeacucar.com/img/uploads/1/227/23204227x200x200.jpeg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(5, 'Caderno Espiral 1/4 Neon Azul 80 fls', 'Caderno Espiral 1/4 Neon Azul 80 fls', 
'80f', 19.90,  'https://static.paodeacucar.com/img/uploads/1/925/19511925x200x200.jpeg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(5, 'Caderno 96 folhas grafics mormaii', 'Caderno 96 folhas grafics mormaii', 
'96f', 59.00,  'https://static.paodeacucar.com/img/uploads/1/298/23457298x200x200.jpeg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(6, 'Conjunto De Atividades - Sos Resgate Ambulância', 'Conjunto De Atividades - Sos Resgate Ambulância - Elka', 
'Branco', 108.50,  'https://static.paodeacucar.com/img/uploads/1/785/23260785x200x200.jpeg', 1);

insert into produto(id_categoria, nome, descricao, unidade, preco, url_foto, id_mercado)
values(6, 'Jogo Monopoly - Clássico', 'Jogo Monopoly - Clássico - Hasbro', 
'Unissex', 125.70,  'https://static.paodeacucar.com/img/uploads/1/324/23264324x200x200.jpeg', 1);




insert into pedido(id_mercado, id_usuario, dt_pedido, vl_subtotal, vl_entrega, vl_total, endereco, bairro, cidade, uf, cep)
values(1, 1, current_timestamp(), 77.10, 8.50, 85.60, 'Av Paulista, 1500', 'Bela Vista', 'São Paulo', 'SP', '03015-500');

insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) values(1, 1, 2, 9.75, 19.50);
insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total) values(1, 3, 12, 4.80, 57.60);

insert into mercado(nome, endereco, bairro, cidade, uf, cep, dt_cadastro, vl_entrega, vl_compra_min,
					ind_entrega, ind_retira)
values('Extra', 'Av. Paes de Barros, 152', 'Mooca', 'São Paulo', 'SP', '01520-520', current_timestamp(), 
		10, 50, 'S', 'S');
        
insert into mercado(nome, endereco, bairro, cidade, uf, cep, dt_cadastro, vl_entrega, vl_compra_min,
					ind_entrega, ind_retira)
values('Supermercado Dia', 'Av. Ipiranga, 2000', 'Centro', 'São Paulo', 'SP', '09999-520', current_timestamp(), 
		0, 100, 'N', 'S');        
        

/*-------------------------------------------------------------*/

select * from usuario;
select * from mercado;
select * from produto_categoria;
select * from produto;
select * from pedido;
select * from pedido_item;







