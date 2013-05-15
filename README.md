## CFT: CoffeeScript fragment templates

CFT lets you embed [CoffeeScript](http://coffeescript.org/) in your markup. It's a lot like [Eco](https://github.com/sstephenson/eco), except it generates [Document Fragments](https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment?redirectlocale=en-US&redirectslug=DOM%2FDocumentFragment) instead of strings.


    <% @observe @post => %>
      <!-- Run whenever post changes -->

      <span><%= @post.get('name') %></span>
    <% end %>


    <% @observeEach posts = Post.all() (post) => %>
      <!-- Run whenever we create/update/change a post -->
    <% end %>