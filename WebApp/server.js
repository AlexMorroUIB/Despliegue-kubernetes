require('dotenv').config()
const express = require('express')
const path = require('path')
const http = require('http')
const PORT = 80
const storageFunctions = require('./storageFunctions.js')

const app = express()
const router = express.Router()

app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'src/index.html'))
})


app.get('/dbConnection', async (req, res) => {
  try {
    let test = await storageFunctions.DBConnect()
    res.send({ value: test })
  } catch (err) {
    res.send({ value: false })
  }
});
app.get('/redisConnection', async (req, res) => {
  try {
    let test = await storageFunctions.redisConnect()
    res.send({ value: test })
  } catch (err) {
    res.send({ value: false })
  }
})

app.get('/selectData', (req, res) => {
  storageFunctions.selectData(req, res)
})

app.get('/getData', (req, res) => {
  storageFunctions.getData(req, res)
})

app.get('/getInstancia', (req, res) => {
  res.status(200).send({ numero: process.env.INSTANCIA })
})

// Health check endpoint
router.use((req, res, next) => {
  res.header('Access-Control-Allow-Methods', 'GET')
  next()
})

router.get('/health', (req, res) => {
  res.status(200).send('Ok')
})

app.use(express.static(path.join(__dirname, 'src')))
app.use('/', router)
// Crea el servidor
http.createServer(app).listen(PORT)

process.on('unhandledRejection', (error, promise) => {
  console.log(promise)
  console.log(error)
})
