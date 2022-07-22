import mysql from 'mysql';

// Conexao com o banco
const db = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "12345",
    database: "meu_mercado"
});


export default db;