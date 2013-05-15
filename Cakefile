{exec} = require 'child_process'

run = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.warn stderr if stderr
    console.log stdout if stdout
    callback?() unless err

build = (callback) ->
  run 'coffee -co lib src', callback
  run 'pegjs src/grammar.pegjs lib/grammar.js'

bundle = (callback) ->
  run 'npm install', callback

task "build", "Build lib/ from src/", ->
  build()

task "test", "Run tests", ->
  build ->
    run 'mocha --compilers coffee:coffee-script'

task "dist", "Generate dist/cft.js", ->
  build -> bundle ->
    fs     = require("fs")
    coffee = require("coffee-script").compile

    uglify = (source) ->
      require("uglify-js").minify(source, {fromString: true}).code

    read = (filename) ->
      fs.readFileSync "#{__dirname}/#{filename}", "utf-8"

    stub = (identifier) -> """
      if (typeof #{identifier} !== 'undefined' && #{identifier} != null) {
        module.exports = #{identifier};
      } else {
        throw 'Cannot require \\'' + module.id + '\\': #{identifier} not found';
      }
    """

    version = JSON.parse(read "package.json").version

    modules =
      "cft":              read "lib/index.js"
      "./compiler":       read "lib/compiler.js"
      "./preprocessor":   read "lib/preprocessor.js"
      "./scanner":        read "lib/scanner.js"
      "./util":           read "lib/util.js"
      "./grammar":        read "lib/grammar.js"
      "coffee-script":    stub "CoffeeScript"

    pkg = for name, source of modules
      """
        '#{name}': function(module, require, exports) {
          #{source}
        }
      """

    header = """
      /**
       * CFT Compiler v#{version}
       * http://github.com/maccman/cft
       *
       * Copyright (c) 2013 Alex MacCaw
       * Released under the MIT License
       */
    """

    source = uglify """
      this.cft = (function(modules) {
        return function require(name) {
          var fn, module = {id: name, exports: {}};
          if (fn = modules[name]) {
            fn(module, require, module.exports);
            return module.exports;
          } else {
            throw 'Cannot find module \\'' + name + '\\'';
          }
        };
      })({
        #{pkg.join ',\n'}
      })('cft');
    """

    try
      fs.mkdirSync "#{__dirname}/dist", 0o0755
    catch err

    fs.writeFileSync "#{__dirname}/dist/cft.js", "#{header}\n#{source}"
