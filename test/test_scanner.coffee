# {scan} = require '../lib/scanner'
# assert = require('assert')

# describe 'Scanner', ->
#   it '<% %>', ->
#     tokens = scan "<% %>"
#     assert.deepEqual([{
#       type: 'eco',
#       tag: 'expression',
#       content: '',
#       indent: false
#     }], tokens)