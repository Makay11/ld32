exec = require("child_process").exec
spawn = require("child_process").spawn
Hapi = require("hapi")
req = require("request")
Storage = require("node-storage")

IS_DEV = process.argv[2]

startServer = ->
  server = new Hapi.Server()
  server.connection address: "0.0.0.0", port: 6900

  server.route
    method: "GET"
    path: "/"
    handler: (request, reply) ->
      reply.file("app/dist/templates/index.html")

  server.route
    method: "GET"
    path: "/{path*}"
    handler: (request, reply) ->
      reply.file("app/dist/" + request.params.path)

  server.start ->
      console.log "Server running at:", server.info.uri

if IS_DEV
  spawn "node_modules/jade/bin/jade.js", "--watch --pretty app/src/templates --out app/dist/templates".split(" ")#, stdio: "inherit"
  spawn "node_modules/stylus/bin/stylus", "--watch app/src/stylesheets --out app/dist/stylesheets".split(" ")#, stdio: "inherit"
  exec "node_modules/coffeescript-concat/coffeescript-concat -I app/src/js -o app/dist/js/app", ->
    spawn("node_modules/coffee-script/bin/coffee", "--compile --bare app/dist/js/app".split(" "), stdio: "inherit").on "close", ->
      exec "rm -rf app/dist/js/app"
      startServer()
else
  startServer()
