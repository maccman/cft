Scanner = require "../scanner"
util    = require "../util"
String  = require("./string")

module.exports = class Preprocessor
  @preprocess: (source) ->
    preprocessor = new Preprocessor source
    preprocessor.preprocess()

  constructor: (@source) ->
    @output   = ""
    @level    = 0
    @index    = 0
    @captures = []

    @record "#{@elementVar()} = document.createDocumentFragment()"

  preprocess: ->
    for token in Scanner.scanNodes(@source)
      @[token.type]?.call(this, token)
    @record "return #{@elementVar()}"
    @output

  # Private

  record: (lines) ->
    for line in lines.split("\n") when line
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
    @fail 'Unexpected traverse' if @index < 0

  traverseDown: ->
    @index++

  append: (code) ->
    @record "#{@elementVar()}.appendChild #{code}"

  appendParent: (code) ->
    @record "#{@elementVar @index-1}.appendChild #{code}"

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
      @record "#{@elementVar()} = document.createDocumentFragment()"

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
    @record token.content + token.directive

  eco_escapedContent: (token) ->
    if token.directive
      @fail 'Directive provided for escaped content'
    else
      @append "document.createTextNode __escape #{token.content}"

  eco_content: (token) ->
    @append "__createFragment #{token.content + token.directive}"

  cdata: (token) ->
    # Strip cdata

  comment: (token) ->
    # Strip comments

  doctype: (token) ->
    # Noop

  script: (token) ->
    # Noop

  # As defined in the HTML spec
  # - http://www.w3.org/TR/html-markup/syntax.html#syntax-elements
  voidElements: [
    'area','base','br','col','command','embed',
    'hr','img','input','keygen','link','meta',
    'param','source','track','wbr'
  ]

  element: (token) ->
    if token.tag in @voidElements
      @element_inline(token)
    else
      @["element_#{token.variant}"].call(this, token)

  element_open: (token) ->
    @traverseDown()

    element = @elementVar()
    @record "#{element} = document.createElement(#{util.inspect token.tag})"
    @recordElementAttributes(element, token.attributes)
    @appendParent(element)

  element_close: (token) ->
    @traverseUp()

  element_inline: (token) ->
    @record "__curr = document.createElement(#{util.inspect token.tag})"
    @recordElementAttributes("__curr", token.attributes)
    @append "__curr"

  style: (token) ->
    @record "__curr = document.createElement('style')"
    @recordElementAttributes("__curr", token.attributes)
    @record "__curr.innerHTML = #{util.inspect token.content}"
    @append "__curr"

  text: (token) ->
    @append "document.createTextNode(#{util.inspect token.content})"

  recordElementAttributes: (element, attributes) ->
    for attr in attributes
      @recordElementAttribute(element, attr.name, attr.value)

  recordElementAttribute: (element, name, value = '') ->
    if value.match /<%/
      @record "__value = do =>"
      @indent()
      @record String.preprocess(value)
      @dedent()

      @record "#{element}.setAttribute(#{util.inspect name}, __value)"
    else
      @record "#{element}.setAttribute(#{util.inspect name}, #{util.inspect value})"
