// Generated by CoffeeScript 1.6.2
(function() {
  var escape, makeFragment, safe, sanitize;

  sanitize = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else if (value != null) {
      return escape(value);
    } else {
      return "";
    }
  };

  safe = function(value) {
    var result;

    if (value == null) {
      value = '';
    }
    if (value && value.ecoSafe) {
      return value;
    } else {
      result = new String(value);
      result.ecoSafe = true;
      return result;
    }
  };

  escape = function(value) {
    return ("" + value).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\x22/g, "&quot;");
  };

  makeFragment = function(value, element) {
    var range;

    element || (element = document.createElement('div'));
    range = document.createRange();
    range.setStart(element, 0);
    range.collapse(false);
    return range.createContextualFragment(value);
  };

}).call(this);