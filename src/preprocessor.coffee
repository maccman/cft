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
    @index    = 0
    @captures = []

    @record "#{@elementVar()} = document.createDocumentFragment()"

  preprocess: ->
    for token in @scanner.scan()
      @[token.type]?.call(this, token)
    @record "return #{@elementVar()}"
    @output

  # Private

  record: (line) ->
    @output += util.repeat "  ", @level
    @output += line + "\n"

  indent: ->
    @level++

  dedent: ->
    @level--
    @fail 'Unexpected dedent' if @level < 0

  elementVar: (index = @index) ->
    "__element#{index}"

  traverseUp: ->
    @index--

  traverseDown: ->
    @index++

  append: (code) ->
    @record "#{@elementVar()}.appendChild #{code}"

  appendParent: (code) ->
    @record "#{@elementVar @index-1}.appendChild #{code}"

  capture: (token, callback) ->
    if token.dedent
      @dedent()

    if token.directive
      @record "parentNode = #{@elementVar()}"

    callback.call(this, token)

    if token.indent or token.directive
      @indent()

    if token.directive
      @captures.unshift @level
      @traverseDown()
      @record "#{@elementVar()} = document.createDocumentFragment()"

  fail: (msg) ->
    throw new Error(msg)

  eco: (token) ->
    @["eco_#{token.tag}"].call(this, token)

  eco_end: (token) ->
    if @captures[0] is @level
      @captures.shift()
      @record(@elementVar())
    @traverseUp()
    @dedent()

  eco_leftLiteral: (token) ->
    @append "document.createTextNode('<%')"

  eco_rightLiteral: (token) ->
    @append "document.createTextNode('%>')"

  eco_expression: (token) ->
    @capture token, =>
      @record token.content + token.directive

  eco_escapedContent: (token) ->
    @fail 'Directive provided for escaped content' if token.directive
    @capture token, =>
      @append "document.createTextNode __escape #{token.content}"

  eco_content: (token) ->
    @capture token, =>
      @append "__createFragment #{token.content}" + token.directive

  cdata: (token) ->
    # Strip cdata

  comment: (token) ->
    # Strip comments

  doctype: (token) ->
    # Noop

  script: (token) ->
    # Noop

  element: (token) ->
    @["element_#{token.variant}"].call(this, token)

  element_open: (token) ->
    element = @elementVar(++@index)

    @record "#{element} = document.createElement(#{util.inspect token.tag})"

    for attr in token.attributes
      @record "#{element}.setAttribute(#{util.inspect attr.name}, #{util.inspect attr.value})"

    @appendParent(element)

  element_close: (token) ->
    @traverseUp()

  element_inline: (token) ->
    @record "__curr = document.createElement(#{util.inspect token.tag})"

    for attr in token.attributes
      @record "__curr.setAttribute(#{util.inspect attr.name}, #{util.inspect attr.value})"

    @append("__curr")

  style: (token) ->
    @record "__curr = document.createElement('style')"

    for attr in token.attributes
      @record "__curr.setAttribute(#{util.inspect attr.name}, #{util.inspect attr.value})"

    @record "__curr.innerHTML = #{util.inspect token.content}"
    @append "__curr"

  text: (token) ->
    @append "document.createTextNode(#{util.inspect token.content})"
