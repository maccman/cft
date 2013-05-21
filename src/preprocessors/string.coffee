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

    @record "#{@outVar()} = []"

  preprocess: ->
    for token in Scanner.scanString(@source)
      @[token.type]?.call(this, token)
    @record "return #{@outVar()}.join('')"
    @output

  # Private

  outVar: (index = @index) ->
    "__out#{index}"

  record: (line) ->
    @output += util.repeat "  ", @level
    @output += line + "\n"

  append: (string) ->
    @record "#{@outVar()}.push #{string}"

  indent: ->
    @level++

  dedent: ->
    @level--
    @fail 'Unexpected dedent' if @level < 0

  traverseUp: ->
    @index--
    @fail 'Unexpected traverse' if @index < 0

  traverseDown: ->
    @index++

  fail: (msg) ->
    throw new Error(msg)

  eco: (token) ->
    if token.dedent
      @dedent()

    @["eco_#{token.tag}"].call(this, token)

    if token.indent or token.directive
      @indent()

    if token.directive
      @captures.unshift @level
      @traverseDown()
      @record "#{@outVar()} = []"

  eco_string: (token) ->
    string = token.content
    @append util.inspectString(string)

  eco_end: (token) ->
    if @captures[0] is @level
      @captures.shift()
      @record "#{@outVar()}.join('')"
      @traverseUp()
    @dedent()

  eco_leftLiteral: (token) ->
    @append util.inspectString('<%')

  eco_rightLiteral: (token) ->
    @append util.inspectString('%>')

  eco_expression: (token) ->
    @record token.content + token.directive

  eco_escapedContent: (token) ->
    if token.directive
      @append "#{token.content} __escape #{token.directive}"
    else
      @append "__escape #{token.content}"

  eco_content: (token) ->
    @append token.content + token.directive
