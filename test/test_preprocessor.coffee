# {preprocess} = require '../lib/preprocessor'
# assert = require('assert')

# describe 'Preprocessor', ->
#   # it '<% %>', ->
#   #   tokens = preprocess "<b><%= @post.get('name') %> <div>test1< hr />test2</div></b>"
#   #   console.log(tokens)

#   # it '<% if %>', ->
#   #   tokens = preprocess "<b><% if @post.get('name'): %> <div style='margin:20px'><%- @post.get('name') %></div> <% end %>"
#   #   console.log(tokens)

#   it '<% if => %>', ->
#     # tokens = preprocess '''
#     #   <% if capture => %>
#     #   <div style='margin:20px'>
#     #   <%- @post.get('name') %>
#     #   </div>
#     #   <% end %>
#     #   <hr />
#     #   <% if @post.get('body'): %>
#     #     <span><%= @post.get('body') %>
#     #   <% end %>
#     # '''
#     # console.log(tokens)