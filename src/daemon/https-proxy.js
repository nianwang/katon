var fs        = require('fs')
var httpProxy = require('http-proxy')
var config    = require('../config')

module.exports.createServer = function() {
  var proxy = httpProxy.createServer({
    target: {
      host: 'localhost',
      port: config.httpPort
    },
    ssl: {
      key: fs.readFileSync(__dirname + '/certs/server.key', 'utf8'),
      cert: fs.readFileSync(__dirname + '/certs/server.crt', 'utf8')
    }
  })
  proxy.on('error', function() {
    // do nothing
  });
  return proxy;
}
