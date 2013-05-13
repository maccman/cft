Scanner = require "./scanner"
util    = require "./util"

module.exports = class Preprocessor
  @preprocess: (source) ->
    preprocessor = new Preprocessor source
    preprocessor.preprocess()

  constructor: (source) ->
    @scanner  = new Scanner source
    @output   = ""
    @level    = 0
    @options  = {}
    @captures = []

  preprocess: ->
    for token in @scanner.scan()
      callback   = @["#{token.type}_#{token.tag}"]
      callback or= @["#{token.type}"]
      callback?.call(this, token)
    @output

  # Private

  record: (line) ->
    @output += util.repeat "  ", @level
    @output += line + "\n"

  eco_end: (token) ->

  eco_leftLiteral: (token) ->

  eco_rightLiteral: (token) ->

  eco_expression: (token) ->

  eco_escapedContent: (token) ->

  eco_content: (token) ->

  cdata: (token) ->
    # Strip cdata

  comment: (token) ->
    # Strip comments

  doctype: (token) ->


  element: (token) ->

  script: (token) ->

  style: (token) ->

  text: (token) ->