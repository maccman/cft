grammar = require('./grammar')

module.exports = class Scanner
  @scan: (source) ->
    @scanNodes(source)

  @scanNodes: (source) ->
    tokens  = []
    scanner = new Scanner source
    scanner.scan('NODES')

  @scanString: (source) ->
    tokens  = []
    scanner = new Scanner source
    scanner.scan('STRING')

  @dedentablePattern: /^(end|when|else|catch|finally)(?:\W|$)/

  constructor: (@source) ->

  scan: (type) ->
    for token in grammar.parse(@source, type)
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