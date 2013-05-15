{compile, precompile} = require "./compiler"
{preprocess} = require "./preprocessor"

module.exports = cft = (source) ->
  if cft.cache
    cft.cache[source] ?= compile source
  else
    compile source

cft.cache = {}

cft.preprocess = preprocess

cft.precompile = precompile

cft.compile = compile

cft.render = (source, data) ->
  (cft source) data