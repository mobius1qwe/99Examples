import { Router } from "express";
import db from '../config/database.js';

const controllerMercados = Router();


controllerMercados.get("/mercados/:id_mercado", function(request, response){    
    
    let ssql = "select * from mercado where id_mercado = ?";

    db.query(ssql, [request.params.id_mercado], function(err, result) {
        if (err) {
            return response.status(500).send(err);
        } else {            
            return response.status(result.length > 0 ? 200 : 404).json(result);
        }
    });
});


controllerMercados.get("/mercados", function(request, response){    
    
    let filtro = [];
    let ssql = "select * from mercado ";
    ssql += "where id_mercado > 0 ";

    if (request.query.busca) {
        ssql += "and nome like ? ";
        filtro.push('%' + request.query.busca + '%');
    }

    if (request.query.ind_entrega) {
        ssql += "and ind_entrega = ? ";
        filtro.push(request.query.ind_entrega);        
    }

    if (request.query.ind_retira) {
        ssql += "and ind_retira = ? ";
        filtro.push(request.query.ind_retira);
    }


    db.query(ssql, filtro, function(err, result) {
        if (err) {            
            return response.status(500).send(err);
        } else {              
            return response.status(200).json(result);
        }
    });
});


controllerMercados.get("/mercados/:id_mercado/categorias", function(request, response){    
    
    let ssql = "select distinct c.id_categoria, c.descricao ";
    ssql += "from produto_categoria c ";
    ssql += "join produto p on (p.id_categoria = c.id_categoria) ";
    ssql += "where p.id_mercado = ? ";
    ssql += "order by c.ordem";

    db.query(ssql, [request.params.id_mercado], function(err, result) {
        if (err) {
            return response.status(500).send(err);
        } else {            
            return response.status(200).json(result);
        }
    });
});

controllerMercados.get("/mercados/:id_mercado/produtos", function(request, response){    
    let filtro = [];

    let ssql = "select p.* ";
    ssql += "from produto p ";
    ssql += "where p.id_mercado = ? ";

    filtro.push(request.params.id_mercado);

    if (request.query.busca) {
        ssql += "and p.nome like ? ";
        filtro.push('%' + request.query.busca + '%');
    }
    
    if (request.query.id_categoria) {
        ssql += "and p.id_categoria = ? ";
        filtro.push(request.query.id_categoria);
    }
    
    db.query(ssql, filtro, function(err, result) {
        if (err) {
            return response.status(500).send(err);
        } else {            
            return response.status(200).json(result);
        }
    });
});



export default controllerMercados;