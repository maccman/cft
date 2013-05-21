CoffeeScript = require "coffee-script"
{preprocess} = require "../preprocessors/node"
{indent}     = require "../util"

exports.precompile = precompile = (source) ->
  script = CoffeeScript.compile preprocess(source), bare: true

  """
    function(__obj) {
      if (!__obj) __obj = {};

      var __escape = __obj.escape = function(value) {
        return ("" + value).replace(/&/g, "&amp;")
                           .replace(/</g, "&lt;")
                           .replace(/>/g, "&gt;")
                           .replace(/\x22/g, "&quot;");
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
      #{indent script, 4}
      }).call(__obj);
    }
  """

exports.compile = (source) ->
  do new Function "return #{precompile source}"