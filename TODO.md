<% observe @post => %>
  <!-- Run whenever post changes -->

  <span><%= @post.get('name') %></span>
<% end %>


<% observeEach posts = Post.all() (post) => %>
  <!-- Run whenever we create/update/change a post -->
<% end %>