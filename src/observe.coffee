exports = @exports or @cftTemplates or= {}

isDigit = (value) ->
  /^\d$/.test(value)

toArray = (value) ->
  Array::slice.call(value, 0)

ObjectObserve = (object, callback) ->
  Object.observe?(object, callback) or object.observe?(callback)

exports.observe = observe = (object, callback) ->
  nodes = []

  render = ->
    fragment = callback(object)
    newNodes = (node for node in fragment.childNodes)
    parent   = nodes[0]?.parentNode

    if parent
      for newNode in newNodes
        parent.insertBefore newNode, nodes[0]

      for node in nodes
        parent.removeChild(node)

    nodes = newNodes
    fragment

  ObjectObserve(object, render)
  render()

exports.observeEach = observeEach = (array, callback) ->
  fragment   = document.createDocumentFragment()
  arrayNodes = []
  arrayClone = toArray(array)

  add = (value, index) ->
    frag     = observe(value, callback)
    newNodes = (n for n in frag.childNodes)

    previousNode = arrayNodes[index - 1]
    previousNode = previousNode?[previousNode.length - 1]
    previousNode?.parentNode.insertBefore(frag, previousNode.nextSibling)

    arrayNodes.splice(index, 0, newNodes)

  remove = (value) ->
    index = arrayClone.indexOf(value)

    for node in arrayNodes[index]
      node.parentNode?.removeChild(node)

    arrayNodes.splice(index, 1)

  changeItem = (object) ->
    fragment = callback(object)
    newNodes = (node for node in fragment.childNodes)
    index    = arrayClone.indexOf(object)
    nodes    = arrayNodes[index]
    parent   = nodes[0]?.parentNode

    return unless parent

    for newNode in newNodes
      parent.insertBefore newNode, nodes[0]

    for node in nodes
      node.parentNode?.removeChild(node)

    arrayNodes[index] = newNodes

  changeArray = ->
    removed = ([item, i] for item, i in arrayClone when item not in array)
    added   = ([item, i] for item, i in array when item not in arrayClone)

    remove(args...) for args in removed
    add(args...) for args in added

    arrayClone = toArray(array)

  for value in array
    frag = callback(value, callback)
    arrayNodes.push((n for n in frag.childNodes))
    fragment.appendChild(frag)

    ObjectObserve value, (changes) ->
      changeItem(changes[0].object)

  ObjectObserve array, (changes) ->
    changes = (c for c in changes when isDigit(c.name))
    changeArray() if changes.length

  fragment

exports.ObservedObject =
  observe: (callback) ->
    handlers = @hasOwnProperty('observeHandlers') and @observeHandlers or= []

    if typeof callback is 'function'
      handlers.push(callback)
    else
      args = arguments
      args = [[{object: this, type: 'updated'}]] unless args.length
      handle(args...) for handle in handlers