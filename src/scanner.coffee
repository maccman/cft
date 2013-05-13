grammar = require('./grammar')

module.exports = class Scanner
  @scan: (source) ->
    tokens  = []
    scanner = new Scanner source
    scanner.scan()

  constructor: (@source) ->

  scan: ->
    grammar.parse(@source)