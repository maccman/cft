this.cftTemplates || (this.cftTemplates = {});
this.cftTemplates.observe = function(object, yield) {
  var nodes = []

  var toArray = function(frag){
    var result = [];
    for (var i = 0; i < frag.childNodes.length; i++) {
      result.push(frag.childNodes[i]);
    };
    return result;
  };

  var render = function(){
    var fragment = yield(object);

    var newNodes = toArray(fragment);
    var parent   = nodes[0] && nodes[0].parentNode;

    if (parent) {
      for (var i = 0; i < newNodes.length; i++)
        parent.insertBefore(newNodes[i], nodes[0])

      for (var j = 0; j < nodes.length; j++)
        parent.removeChild(nodes[j]);
    }

    nodes = newNodes;
    return fragment;
  }

  Object.observe(object, render);
  return render();
};