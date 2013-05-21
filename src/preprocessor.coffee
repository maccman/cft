NodePreprocessor = require('./preprocessors/node')

exports.preprocess = (source) ->
  NodePreprocessor.preprocess(source)