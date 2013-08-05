var http    = require('http');
var cluster = require('cluster');

http.createServer(function (request, response) {
  response.writeHead(200, {'Content-Type': 'text/plain'});

  if (cluster.isWorker) {
    response.end("Hello! I was served from worker no." + cluster.worker.id);
  } else {
    response.end("Hello! I was served by standalone server.");
  }
}).listen(3000);


process.on("message", function (message) {
  console.log(message);
});
