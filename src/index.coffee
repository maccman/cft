{compile, precompile} = require "./compilers/node"
{preprocess}          = require "./preprocessors/node"
StringCompiler        = require "./compilers/string"
StringPreprocessor    = require "./preprocessors/string"

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

# String specic compilation
cft.preprocessString = StringPreprocessor.preprocess
cft.precompileString = StringCompiler.precompile
cft.compileString    = StringCompiler.compile