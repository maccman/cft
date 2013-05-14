grammar = require('./grammar')

module.exports = class Scanner
  @scan: (source) ->
    tokens  = []
    scanner = new Scanner source
    scanner.scan()

  @dedentablePattern: /^(end|when|else|catch|finally)(?:\W|$)/

  constructor: (@source) ->

  scan: ->
    for token in grammar.parse(@source)
      @[token.type]?.call(this, token) or token

  # Private

  eco: (token) ->
    if token.content and @isDedentable(token.content)
      token.dedent = true

    if token.directive
      token.indent = true

    token

  isDedentable: (code) ->
    code.match Scanner.dedentablePattern