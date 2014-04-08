fs     = require 'fs'
config = require '../../config'
env    = require './env'
log    = require './log'

module.exports =

  getKatonCommand: (path) ->
    try
      command = fs.readFileSync("#{path}/.katon")
        .toString()
        .trim()
      log.global.log path, 'Detected .katon'
      command if command isnt ''

  getPackageCommand: (path) ->
    try
      pkg = fs.readFileSync "#{path}/package.json"
      pkg = JSON.parse pkg
      return 'nodemon' if pkg.main?
      return pkg.scripts?.start
    catch e
      if e instanceof SyntaxError
        log.global.error path, "package.json: #{e}"

  getStaticCommand: ->
    'static --port $PORT'

  get: (path, port) ->
    command   = @getKatonCommand path
    command or= @getPackageCommand path
    command or= @getStaticCommand()

    command
      .replace('node ', 'nodemon ')
      .replace('nodemon', config.nodemonPath)
      .replace('static', config.staticPath)
      .replace(/\$PORT/g, port)
      .split ' '
