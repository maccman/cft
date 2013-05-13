<% observe @post => %>
  <!-- Run whenever post changes -->
<% end %>


<% observe posts = Post.all() => %>
  <!-- Run whenever we create/update/change a post -->
<% end %>


var __out = document.createFragment();

result.appendChild(" test ")

__out.appendChild(observe(Post.all, =>
  document.createFragment()
))



function template(context, options) {
var child0 = function anonymous(context,options) {
var buffer = '';
buffer += dom.ambiguousAttr(context, ['blah'], options);
return buffer;
};
var element0, el;
var frag = element0 = document.createDocumentFragment();
element0.appendChild(dom.frag(element0, 'some '));
var element1 = el = document.createElement('div');
dom.appendText(element1, dom.ambiguousContents(element1, context, 'content', true));
element0.appendChild(element1);
element0.appendChild(dom.frag(element0, ' '));
var element1 = el = document.createElement('p');
el.setAttribute('class', child0(context, {rerender:function rerender() { el.setAttribute('class', child0(context, {rerender:rerender}))},element:el,attrName:'class'}));
var element2 = el = document.createElement('span');
element2.appendChild(dom.frag(element2, 'test'));
element1.appendChild(element2);
element0.appendChild(element1);
element0.appendChild(dom.frag(element0, ' done'));
return frag;
}