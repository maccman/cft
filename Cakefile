{exec} = require 'child_process'

run = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.warn stderr if stderr
    callback?() unless err

build = (callback) ->
  run 'coffee -co lib src', callback
  run 'pegjs src/grammar.pegjs lib/grammar.js'

bundle = (callback) ->
  run 'npm install', callback

task "build", "Build lib/ from src/", ->
  build()