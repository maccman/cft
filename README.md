## CFT: CoffeeScript fragment templates

CFT lets you embed [CoffeeScript](http://coffeescript.org/) in your markup. It's a lot like [Eco](https://github.com/sstephenson/eco), except it generates [Document Fragments](https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment?redirectlocale=en-US&redirectslug=DOM%2FDocumentFragment) instead of strings.

Using document fragments for templates lets you do some interesting things, such as dynamic DOM updation. For example:


    <% @observe @post => %>
      <!-- Run whenever post changes -->

      <span><%= @post.get('name') %></span>
    <% end %>


    <% @observeEach User.all() (user) => %>
      <!-- Run whenever we create/update/change a user -->
      <label>Name: <%= user.name %>
    <% end %>

