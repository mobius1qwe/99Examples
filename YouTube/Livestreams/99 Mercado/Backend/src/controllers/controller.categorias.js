import { Router } from "express";
import db from '../config/database.js';

const controllerCategorias = Router();

controllerCategorias.get("/categorias", function(request, response){    
    
    let filtro = [];
    let ssql = "select * from mercado ";
    ssql += "where id_mercado > 0 ";
  
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


export default controllerCategorias;