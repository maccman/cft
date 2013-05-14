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

  indent: ->
    @level++

  dedent: ->
    @level--
    @fail 'Unexpected dedent' if @level < 0

  fail: (msg) ->
    throw new Error(msg)

  eco_end: (token) ->
    @dedent()

  eco_leftLiteral: (token) ->
    @record "__frag.appendChild(document.createTextNode('<%'))"

  eco_rightLiteral: (token) ->
    @record "__frag.appendChild(document.createTextNode('%>'))"

  eco_expression: (token) ->
    @dedent() if token.dedent
    @record token.content
    @indent() if token.indent

  eco_escapedContent: (token) ->
    @record "__frag.appendChild(document.createTextNode(#{token.content}))"

  eco_content: (token) ->
    @record "__frag.appendChild(__makeFragment(#{token.content}))"

  cdata: (token) ->
    # Strip cdata

  comment: (token) ->
    # Strip comments

  doctype: (token) ->
    # Noop

  script: (token) ->
    # Noop

  element: (token) ->
    @record "__curr = document.createElement(#{util.inspect token.tag})"

    for attr in token.attributes
      @record "__curr.setAttribute(#{util.inspect attr.name}, #{util.inspect attr.value})"

    @record "__frag.appendChild __curr"
    variant
    attributes

  style: (token) ->
    @record "__curr = document.createElement('style')"
    @record "__curr.innerHTML = #{util.inspect token.content}"

    for attr in token.attributes
      @record "__curr.setAttribute(#{util.inspect attr.name}, #{util.inspect attr.value})"

    @record "__frag.appendChild __curr"

  text: (token) ->
    @record "__frag.appendChild document.createTextNode(#{util.inspect token.content})"
