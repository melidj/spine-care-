const express = require("express");
const bodyParser = require("body-parser")
const UserRouter = require("./routers/user.router");

const app = express();

const cors = require('cors');
app.use(cors());

app.use(bodyParser.json())

app.use("/",UserRouter);


module.exports = app;