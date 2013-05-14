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

    @record "#{@scope()} = document.createDocumentFragment()"

  preprocess: ->
    for token in @scanner.scan()
      callback   = @["#{token.type}_#{token.tag}"]
      callback or= @["#{token.type}"]
      callback?.call(this, token)
    @output

  # Private

  scope: (index = @index) ->
    "__element#{index}"

  record: (line) ->
    @output += util.repeat "  ", @level
    @output += line + "\n"

  indent: ->
    @level++

  dedent: ->
    @level--
    @fail 'Unexpected dedent' if @level < 0

  fail: (msg) ->
    throw new Error(msg)

  append: (code) ->
    @record "#{@scope @index}.appendChild(#{code})"

  appendParent: (code) ->
    @record "#{@scope @index-1}.appendChild(#{code})"

  eco_end: (token) ->
    @dedent()

  eco_leftLiteral: (token) ->
    @append "document.createTextNode('<%')"

  eco_rightLiteral: (token) ->
    @append "document.createTextNode('%>')"

  eco_expression: (token) ->
    @dedent() if token.dedent
    @record token.content
    @indent() if token.indent

  eco_escapedContent: (token) ->
    @append "document.createTextNode(#{token.content})"

  eco_content: (token) ->
    @append "__makeFragment(#{token.content})"

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
    scope = @scope(++@index)

    @record "#{scope} = document.createElement(#{util.inspect token.tag})"

    for attr in token.attributes
      @record "#{scope}.setAttribute(#{util.inspect attr.name}, #{util.inspect attr.value})"

    @appendParent(scope)

  element_close: (token) ->
    @index--

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
