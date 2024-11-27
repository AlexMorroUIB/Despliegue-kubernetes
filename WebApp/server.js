require('dotenv').config();
const express = require('express')
const path = require('path')
const http = require('http')
const https = require('https')
const fs = require('fs')
const PORT = 443
const options = {
    key: fs.readFileSync("./ssl/cert.crt.key"),
    cert: fs.readFileSync("./ssl/cert.crt")
    //pfx: fs.readFileSync("ssl/AlexMorro.pfx"),
    //passphrase: "1234"
}
const storageFunctions = require('./storageFunctions.js');

const app = express()

app.use(express.static(path.join(__dirname, 'src')))

app.get('/', function (req, res) {
    res.sendFile(path.join(__dirname, 'src/index.html'))
})

app.get('/dbConnection', async (req, res) => {
    try {
        let test = await storageFunctions.DBConnect()
        res.send({value: test});
    } catch
        (err) {
        res.send({value: false});
    }
});
app.get('/redisConnection', async (req, res) => {
    try {
        let test = await storageFunctions.redisConnect()
        res.send({value: test});
    } catch (err) {
        res.send({value: false});
    }
});

app.get('/selectData', (req, res) => {
    storageFunctions.selectData(req, res);
});

app.get('/getData', (req, res) => {
    storageFunctions.getData(req, res);
});

app.get('/getInstancia', (req, res) => {
    res.status(200).send(
        { "numero": process.env.INSTANCIA}
    );
});

https.createServer(options, app).listen(PORT);
//http.createServer(app).listen(PORT)

process.on('unhandledRejection', (error, promise) => {
    console.log(promise)
    console.log(error);
});