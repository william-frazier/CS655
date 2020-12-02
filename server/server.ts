import * as express from "express"
import * as bodyParser from "body-parser"
import { promises } from "fs"
import * as net from "net"
import * as carrier from "carrier"
import * as readline from "readline"
import * as fs from "fs"

var output_filename = process.argv[2]
// var worker_ips = ["172.17.1.9", "172.17.1.10", "172.17.1.11", "172.17.1.12"]
var worker_ips = ["127.0.0.1"]
var num_worker_to_use = 1
const worker_port = 1338 // TODO: change actual port
const total_search_space = 52**5

const app = express()
app.listen(8080, () => {
    console.log("Server listening...")
})

let options = {
    root : '.'
}

app.get('/', (req, res) => {
    res.sendFile("./index.html", options)
})


app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))

app.post('/api/processform', (req, res) => {
    console.log(req.body.md5hash)
    const promise = sendRequest(req.body.md5hash)
    promise.then((result) => {
        console.log(result)
        res.send(result)
    })
})


async function sendRequest(md5hash) {

    return new Promise((resolve, reject) => {
        const length_of_search_for_each_worker = total_search_space/num_worker_to_use;
        for (var i = 0; i < num_worker_to_use; i++) {
            var start_index = (i*length_of_search_for_each_worker).toString()
            var end_index = ((i+1)*length_of_search_for_each_worker).toString()
            if (i == num_worker_to_use - 1) {
                start_index = (i*length_of_search_for_each_worker).toString()
                end_index = total_search_space.toString()
            }
            var string_to_be_send = "{'hash': b'" + md5hash + "', 'index': [" + start_index + "," + end_index + "]}\n"
            var socket = new net.Socket()
            socket.connect(worker_port, worker_ips[i], () => {})
            const beginTime = Date.now()
            socket.write(string_to_be_send)
            var my_carrier = carrier.carry(socket)
            my_carrier.on('line', (line) => {
                if (line == "Fail to find password") {
                    socket.destroy()
                } else {
                    const totalTime = Date.now() - beginTime
                    console.log(totalTime)
                    fs.appendFile(output_filename, totalTime.toString() + "\r\n", (err) => {
                        if (err) throw err
                    })
                    resolve(line)
                }
            })
        }
    })
}

// add/remove workers

var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})

var changeNumofWorkers = function () {
    rl.question("Number of workers to use?", function(num) {
        var requested_num_worker_to_use = parseInt(num)
        if (isNaN(requested_num_worker_to_use)) {
            
        } else if ((requested_num_worker_to_use < 1) || (requested_num_worker_to_use > worker_ips.length)) {
            
        } else {
            num_worker_to_use = requested_num_worker_to_use;
        }
        console.log("Current:" + num_worker_to_use)
        changeNumofWorkers()
    })
}

changeNumofWorkers()
