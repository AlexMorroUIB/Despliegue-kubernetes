let dbbox = document.getElementById("dbstatus")
let cachebox = document.getElementById("cachestatus")
let tabla = document.getElementById("tabla")
let tablaRedis = document.getElementById("tablaRedis")
let titulo = document.getElementById("titulo")

document.addEventListener('DOMContentLoaded', () => {
    getInstancia();
})

async function getInstancia() {
    try {
        await fetch('/getInstancia').then(response => response.json())
            .then(data => {
                titulo.innerHTML = "Web app in docker | Contenedor " + data.numero;
            }).catch(err => {
                console.log(err)
            })
    } catch (err) {
        console.log(err)
    }
}

// Every 1000 ms (1 sec) check status of connections
setInterval(checkConnections, 1000)

async function checkConnections() {
    try {
        await fetch('/dbConnection').then(response => response.json())
            .then((data) => {
                if (data.value) {
                    dbbox.innerHTML = `DB OK <span class="badge text-bg-success rounded-pill"> </span>`
                } else {
                    dbbox.innerHTML = `DB Down <span class="badge text-bg-danger rounded-pill"> </span>`
                }
            }).catch(err => {
                console.log(err)
            })
        await fetch('/redisConnection').then(response => response.json())
            .then((data) => {
                if (data.value) {
                    cachebox.innerHTML = `Redis OK <span class="badge text-bg-success rounded-pill"> </span>`
                } else {
                    cachebox.innerHTML = `Redis Down <span class="badge text-bg-danger rounded-pill"> </span>`
                }
            }).catch(err => {
                console.log(err)
            })
    } catch (err) {
        console.log(err)
    }
}

async function selectData() {
    let datosTabla = `<div>`
    try {
        await fetch('/selectData').then(response => response.json())
            .then((data) => {
                for (let i = 0; i < data.length; i++) {
                    datosTabla += `<tr>
                        <th scope="row">${data[i].use_ID}</th>
                        <td>${data[i].use_name}</td>
                        <td>${data[i].use_surname}</td>
                    </tr>`
                }
                datosTabla += `</div>`
                tabla.innerHTML = datosTabla
            }).catch(err => {
                console.log(err)
            })
    } catch (err) {
        console.log(err)
    }
}

async function getData() {
    let datosTabla = `<div>`
    try {
        await fetch('/getData').then(response => response.json())
            .then(data => {
                let datos = data.tabla
                if (datos == null) {
                    datosTabla += `<p>No hay datos en caché</p>`
                } else {
                    for (let i = 0; i < datos.length; i++) {
                        datosTabla += `<tr>
                        <th scope="row">${datos[i].use_ID}</th>
                        <td>${datos[i].use_name}</td>
                        <td>${datos[i].use_surname}</td>
                    </tr>`
                    }
                }
                datosTabla += `</div>`
                tablaRedis.innerHTML = datosTabla
            }).catch(err => {
                console.log(err)
            })
    } catch (err) {
        console.log(err)
    }
}
