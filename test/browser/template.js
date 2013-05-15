(function() {
  this.cftTemplates || (this.cftTemplates = {});
  this.cftTemplates["template"] = function(__obj) {
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
        var parentNode, __element0, __element1,
        _this = this;
      
      __element0 = document.createDocumentFragment();
      
      __element0.appendChild(document.createTextNode("\n"));
      
      __element1 = document.createElement("h1");
      
      __element0.appendChild(__element1);
      
      __element1.appendChild(document.createTextNode("Template"));
      
      parentNode = __element0;
      
      __element0.appendChild(__createFragment(this.observe(this.project, function() {
        var __element2;
      
        __element1 = document.createDocumentFragment();
        __element2 = document.createElement("p");
        __element1.appendChild(__element2);
        __element2.appendChild(document.createTextNode("Project Name: "));
        __element2.appendChild(document.createTextNode(__escape(_this.project.name)));
        return __element1;
      })));
      
      parentNode = __element0;
      
      __element0.appendChild(__createFragment(this.observeEach(this.project.users, function(user) {
        var __element2;
      
        __element1 = document.createDocumentFragment();
        __element2 = document.createElement("p");
        __element1.appendChild(__element2);
        __element2.appendChild(document.createTextNode("User name: "));
        __element2.appendChild(document.createTextNode(__escape(user.name)));
        return __element1;
      })));
      
      return __element0;
      
    }).call(__obj);
  };
}).call(this);
