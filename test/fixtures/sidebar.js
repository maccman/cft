(function() {
  this.cftTemplates || (this.cftTemplates = {});
  this.cftTemplates["sidebar"] = function(__obj) {
    if (!__obj) __obj = {};
  
    var __escape = __obj.escape = function(value) {
      return ("" + value).replace(/&/g, "&amp;")
                         .replace(/</g, "&lt;")
                         .replace(/>/g, "&gt;")
                         .replace(/"/g, "&quot;");
    }
  
    var __createFragment = __obj.createFragment = function(value, element) {
      if (value instanceof DocumentFragment) return value;
      element || (element = document.createElement('div'));
      var range = document.createRange();
      range.setStart(element, 0);
      range.collapse(false);
      return range.createContextualFragment(value);
    };
  
    return (function() {
        var __curr, __element0, __element1, __element2, __element3,
        _this = this;
      
      __element0 = document.createDocumentFragment();
      
      __element1 = document.createElement("header");
      
      __element0.appendChild(__element1);
      
      __element2 = document.createElement("a");
      
      __element2.setAttribute("class", "logo about");
      
      __element1.appendChild(__element2);
      
      __element2.appendChild(document.createTextNode("B"));
      
      __element2 = document.createElement("nav");
      
      __element1.appendChild(__element2);
      
      __element3 = document.createElement("a");
      
      __element3.setAttribute("class", "popular active");
      
      __element3.setAttribute("data-state", "popular");
      
      __element3.setAttribute("title", "Popular");
      
      __element2.appendChild(__element3);
      
      __element3 = document.createElement("a");
      
      __element3.setAttribute("class", "newest");
      
      __element3.setAttribute("data-state", "newest");
      
      __element3.setAttribute("title", "Newest");
      
      __element2.appendChild(__element3);
      
      __curr = document.createElement("input");
      
      __curr.setAttribute("type", "search");
      
      __curr.setAttribute("tabindex", "1");
      
      __curr.setAttribute("incremental", true);
      
      __element1.appendChild(__curr);
      
      __element1 = document.createElement("section");
      
      __element1.setAttribute("class", "list posts-list posts-popular state");
      
      __element1.setAttribute("data-state", "popular");
      
      __element0.appendChild(__element1);
      
      __element1.appendChild(__createFragment(this.helpers.observe(this.popularPosts, function() {
        __element2 = document.createDocumentFragment();
        __element2.appendChild(__createFragment(_this.view('posts/items')({
          posts: _this.popularPosts
        })));
        return __element2;
      })));
      
      return __element0;
      
    }).call(__obj);
  };
}).call(this);
