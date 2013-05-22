(function() {
  this.cftTemplates || (this.cftTemplates = {});
  this.cftTemplates["user"] = function(__obj) {
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
        var __element0, __element1, __element2,
        _this = this;
      
      __element0 = document.createDocumentFragment();
      
      __element1 = document.createElement("footer");
      
      __element0.appendChild(__element1);
      
      __element1.appendChild(__createFragment(this.helpers.observe(this.user, function() {
        var avatar_url, __curr, __element2, __element3, __value;
      
        __element2 = document.createDocumentFragment();
        __element3 = document.createElement("a");
        __element3.setAttribute("class", "config btn profile");
        __element3.setAttribute("title", "Account");
        __element2.appendChild(__element3);
        if (avatar_url = _this.user.get('avatar_url')) {
          __curr = document.createElement("img");
          __curr.setAttribute("class", "avatar");
          __value = (function() {
            var __out0;
      
            __out0 = [];
            __out0.push(__escape(avatar_url));
            return __out0.join('');
          })();
          __curr.setAttribute("src", __value);
          __element3.appendChild(__curr);
        }
        return __element2;
      })));
      
      __element2 = document.createElement("span");
      
      __element1.appendChild(__element2);
      
      __element2 = document.createElement("a");
      
      __element2.setAttribute("class", "add btn newPost");
      
      __element2.setAttribute("title", "New post");
      
      __element1.appendChild(__element2);
      
      return __element0;
      
    }).call(__obj);
  };
}).call(this);
