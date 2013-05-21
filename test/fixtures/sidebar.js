(function() {
  this.cftTemplates || (this.cftTemplates = {});
  this.cftTemplates["sidebar"] = function(__obj) {
    if (!__obj) __obj = {};
  
    var __escape = __obj.escape = function(value) {
      return ("" + value).replace(/&/g, "&amp;")
                         .replace(/</g, "&lt;")
                         .replace(/>/g, "&gt;")
                         .replace(/"/g, "&quot;");
    };
  
    var __createFragment = __obj.createFragment = function(value, element) {
      if (value instanceof DocumentFragment) return value;
      element || (element = document.createElement('div'));
      var range = document.createRange();
      range.setStart(element, 0);
      range.collapse(false);
      return range.createContextualFragment(value);
    };
  
    return (function() {
        var __curr, __element0, __element1, __element2, __element3, __value,
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
      
      _curr.setAttribute("type", "search");
      
      _curr.setAttribute("tabindex", "1");
      
      _curr.setAttribute("incremental", "");
      
      __element1.appendChild(__curr);
      
      __element1 = document.createElement("section");
      
      __value = (function() {
        var __out0;
      
        __out0 = [];
        __out0.push('list posts-list posts-popular ');
        __out0.push(this.state(function() {
          var __out1;
      
          __out1 = [];
          __out1.push('state');
          return __out1.join('');
        }));
        return __out0.join('');
      })();
      
      __element1.setAttribute("class", __value);
      
      __element1.setAttribute("data-state", "popular");
      
      __element0.appendChild(__element1);
      
      __element1.appendChild(__createFragment(this.helpers.observe(this.popularPosts, function() {
        var post, _i, _len, _ref;
      
        __element2 = document.createDocumentFragment();
        _ref = _this.popularPosts;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          post = _ref[_i];
          __element2.appendChild(__createFragment(_this.helpers.observe(post, function() {
            __element3 = document.createDocumentFragment();
            __element3.appendChild(__createFragment(_this.view('posts/item')({
              post: post
            })));
            return __element3;
          })));
        }
        return __element2;
      })));
      
      __element0;
      
    }).call(__obj);
  };
}).call(this);
