{preprocess} = require '../lib/preprocessor'
{compile} = require '../lib/compiler'
assert = require('assert')

describe 'Compiler', ->
  # it '<% %>', ->
  #   tokens = preprocess "<b><%= @post.get('name') %> <div>test1< hr />test2</div></b>"
  #   console.log(tokens)

  # it '<% if %>', ->
  #   source = compile "<b><% if @post.get('name'): %> <div style='margin:20px'><%- @post.get('name') %></div> <% end %>"
  #   console.log(source)

  it '<% if => %>', ->
    source = compile '''
      <% @capture => %>
      <div style='margin:20px'>
      <%- @post.get('name') %>
      </div>
      <% end %>
      <hr />
      <% if @post.get('body'): %>
        <span><%= @post.get('body') %>
      <% end %>
    '''
    console.log(source)