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
        var __element0,
        _this = this;
      
      __element0 = document.createDocumentFragment();
      
      __element0.appendChild(__createFragment(this.helpers.observe(this.user, function() {
        var __element1;
      
        __element1 = document.createDocumentFragment();
        if (_this.user.present) {
          __element1.appendChild(document.createTextNode(__escape(_this.user.get('name'))));
        } else {
          __element1.appendChild(document.createTextNode("No user\n  "));
        }
        return __element1;
      })));
      
      __element0;
      
    }).call(__obj);
  };
}).call(this);
