Scanner = require "../scanner"
util    = require "../util"

module.exports = class Preprocessor
  @preprocess: (source) ->
    preprocessor = new Preprocessor source
    preprocessor.preprocess()

  constructor: (@source) ->
    @output   = ""
    @level    = 0
    @index    = 0
    @captures = []
    @record '__out = []'

  preprocess: ->
    for token in Scanner.scanString(@source)
      @[token.type]?.call(this, token)
    @record '__out.join("")'
    @output

  # Private

  record: (line) ->
    @output += util.repeat "  ", @level
    @output += line + "\n"

  append: (string) ->
    @record "__out.push #{string}"

  indent: ->
    @level++

  dedent: ->
    @level--
    @fail 'Unexpected dedent' if @level < 0

  fail: (msg) ->
    throw new Error(msg)

  capture: (token, callback) ->
    if token.dedent
      @dedent()

    callback.call(this, token)

    if token.indent or token.directive
      @indent()

    if token.directive
      @captures.unshift @level
      @record "__out = []"

  eco: (token) ->
    @["eco_#{token.tag}"].call(this, token)

  eco_string: (token) ->
    string = token.content
    @append util.inspectString(string)

  eco_end: (token) ->
    if @captures[0] is @level
      @captures.shift()
      @record '__out.join("")'
    @dedent()

  eco_leftLiteral: (token) ->
    @append util.inspectString('<%')

  eco_rightLiteral: (token) ->
    @append util.inspectString('%>')

  eco_expression: (token) ->
    @capture token, ->
      @record token.content

  eco_escapedContent: (token) ->
    @capture token, ->
      @append token.content

  eco_content: (token) ->
    @capture token, ->
      @append token.content
