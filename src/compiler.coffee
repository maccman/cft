CoffeeScript = require "coffee-script"
{preprocess} = require "./preprocessor"
{indent}     = require "./util"

exports.compile = compile = (source) ->
  script = CoffeeScript.compile preprocess(source), bare: true

  """
    function(__obj) {
      var sanitize = function(value) {
        if (value && value.cftSafe) {
          return value;
        } else if (value != null) {
          return __escape(value);
        } else {
          return "";
        }
      }, escape = function(value) {
        return ("" + value).replace(/&/g, "&amp;")
                           .replace(/</g, "&lt;")
                           .replace(/>/g, "&gt;")
                           .replace(/\x22/g, "&quot;");
      }, createFragment = function(value, element) {
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
