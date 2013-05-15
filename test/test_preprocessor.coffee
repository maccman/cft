{preprocess} = require '../lib/preprocessor'
assert = require('assert')

describe 'Preprocessor', ->
  # it '<% %>', ->
  #   tokens = preprocess "<b><%= @post.get('name') %> <div>test1< hr />test2</div></b>"
  #   console.log(tokens)

  # it '<% if %>', ->
  #   tokens = preprocess "<b><% if @post.get('name'): %> <div style='margin:20px'><%- @post.get('name') %></div> <% end %>"
  #   console.log(tokens)

  it '<% if => %>', ->
    tokens = preprocess '''
    <%- @formFor @project, (form) => %>
      <label>Name:</label>
      <%= form.textField "name" %>
    <% end %>
    '''
    console.log(tokens)