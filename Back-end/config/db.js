const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb+srv://melishadjayawardana:inQvbCTx80WWfnOF@cluster0.vtkoq.mongodb.net/spinecaredb?retryWrites=true&w=majority').on('open',()=>{
    console.log("MongoDB Connected");}).on('error',()=>{
    console.log("MongoDB Connection error");
});

module.exports = connection;