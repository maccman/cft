{preprocess} = require '../lib/preprocessor'
assert = require('assert')

describe 'Preprocessor', ->
  it '<% %>', ->
    tokens = preprocess "<b><%= @post.get('name') %> <div>test1< hr />test2</div></b>"
    console.log(tokens)

  it '<% if %>', ->
    tokens = preprocess "<b><% if @post.get('name'): %> <div><%- @post.get('name') %></div> <% end %>"
    console.log(tokens)