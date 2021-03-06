// Generated by CoffeeScript 1.6.2
(function() {
  var ObjectObserve, exports, isDigit, observe, observeEach, toArray,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  exports = this.exports || this.cftTemplates || (this.cftTemplates = {});

  isDigit = function(value) {
    return /^\d$/.test(value);
  };

  toArray = function(value) {
    return Array.prototype.slice.call(value, 0);
  };

  ObjectObserve = function(object, callback) {
    return (typeof Object.observe === "function" ? Object.observe(object, callback) : void 0) || (typeof object.observe === "function" ? object.observe(callback) : void 0);
  };

  exports.observe = observe = function(object, callback) {
    var nodes, render;

    nodes = [];
    render = function() {
      var fragment, newNode, newNodes, node, parent, _i, _j, _len, _len1, _ref;

      fragment = callback(object);
      newNodes = (function() {
        var _i, _len, _ref, _results;

        _ref = fragment.childNodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          node = _ref[_i];
          _results.push(node);
        }
        return _results;
      })();
      parent = (_ref = nodes[0]) != null ? _ref.parentNode : void 0;
      if (parent) {
        for (_i = 0, _len = newNodes.length; _i < _len; _i++) {
          newNode = newNodes[_i];
          parent.insertBefore(newNode, nodes[0]);
        }
        for (_j = 0, _len1 = nodes.length; _j < _len1; _j++) {
          node = nodes[_j];
          parent.removeChild(node);
        }
      }
      nodes = newNodes;
      return fragment;
    };
    ObjectObserve(object, render);
    return render();
  };

  exports.observeEach = observeEach = function(array, callback) {
    var add, arrayClone, arrayNodes, changeArray, changeItem, frag, fragment, n, remove, value, _i, _len;

    fragment = document.createDocumentFragment();
    arrayNodes = [];
    arrayClone = toArray(array);
    add = function(value, index) {
      var frag, n, newNodes, previousNode;

      frag = observe(value, callback);
      newNodes = (function() {
        var _i, _len, _ref, _results;

        _ref = frag.childNodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          n = _ref[_i];
          _results.push(n);
        }
        return _results;
      })();
      previousNode = arrayNodes[index - 1];
      previousNode = previousNode != null ? previousNode[previousNode.length - 1] : void 0;
      if (previousNode != null) {
        previousNode.parentNode.insertBefore(frag, previousNode.nextSibling);
      }
      return arrayNodes.splice(index, 0, newNodes);
    };
    remove = function(value) {
      var index, node, _i, _len, _ref, _ref1;

      index = arrayClone.indexOf(value);
      _ref = arrayNodes[index];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        if ((_ref1 = node.parentNode) != null) {
          _ref1.removeChild(node);
        }
      }
      return arrayNodes.splice(index, 1);
    };
    changeItem = function(object) {
      var index, newNode, newNodes, node, nodes, parent, _i, _j, _len, _len1, _ref, _ref1;

      fragment = callback(object);
      newNodes = (function() {
        var _i, _len, _ref, _results;

        _ref = fragment.childNodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          node = _ref[_i];
          _results.push(node);
        }
        return _results;
      })();
      index = arrayClone.indexOf(object);
      nodes = arrayNodes[index];
      parent = (_ref = nodes[0]) != null ? _ref.parentNode : void 0;
      if (!parent) {
        return;
      }
      for (_i = 0, _len = newNodes.length; _i < _len; _i++) {
        newNode = newNodes[_i];
        parent.insertBefore(newNode, nodes[0]);
      }
      for (_j = 0, _len1 = nodes.length; _j < _len1; _j++) {
        node = nodes[_j];
        if ((_ref1 = node.parentNode) != null) {
          _ref1.removeChild(node);
        }
      }
      return arrayNodes[index] = newNodes;
    };
    changeArray = function() {
      var added, args, i, item, removed, _i, _j, _len, _len1;

      removed = (function() {
        var _i, _len, _results;

        _results = [];
        for (i = _i = 0, _len = arrayClone.length; _i < _len; i = ++_i) {
          item = arrayClone[i];
          if (__indexOf.call(array, item) < 0) {
            _results.push([item, i]);
          }
        }
        return _results;
      })();
      added = (function() {
        var _i, _len, _results;

        _results = [];
        for (i = _i = 0, _len = array.length; _i < _len; i = ++_i) {
          item = array[i];
          if (__indexOf.call(arrayClone, item) < 0) {
            _results.push([item, i]);
          }
        }
        return _results;
      })();
      for (_i = 0, _len = removed.length; _i < _len; _i++) {
        args = removed[_i];
        remove.apply(null, args);
      }
      for (_j = 0, _len1 = added.length; _j < _len1; _j++) {
        args = added[_j];
        add.apply(null, args);
      }
      return arrayClone = toArray(array);
    };
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      value = array[_i];
      frag = callback(value, callback);
      arrayNodes.push((function() {
        var _j, _len1, _ref, _results;

        _ref = frag.childNodes;
        _results = [];
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          n = _ref[_j];
          _results.push(n);
        }
        return _results;
      })());
      fragment.appendChild(frag);
      ObjectObserve(value, function(changes) {
        return changeItem(changes[0].object);
      });
    }
    ObjectObserve(array, function(changes) {
      var c;

      changes = (function() {
        var _j, _len1, _results;

        _results = [];
        for (_j = 0, _len1 = changes.length; _j < _len1; _j++) {
          c = changes[_j];
          if (isDigit(c.name)) {
            _results.push(c);
          }
        }
        return _results;
      })();
      if (changes.length) {
        return changeArray();
      }
    });
    return fragment;
  };

  exports.ObservedObject = {
    observe: function(callback) {
      var args, handle, handlers, _i, _len, _results;

      handlers = this.hasOwnProperty('observeHandlers') && this.observeHandlers || (this.observeHandlers = []);
      if (typeof callback === 'function') {
        return handlers.push(callback);
      } else {
        args = arguments;
        if (!args.length) {
          args = [
            [
              {
                object: this,
                type: 'updated'
              }
            ]
          ];
        }
        _results = [];
        for (_i = 0, _len = handlers.length; _i < _len; _i++) {
          handle = handlers[_i];
          _results.push(handle.apply(null, args));
        }
        return _results;
      }
    }
  };

}).call(this);
