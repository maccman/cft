exports = @exports or @cftTemplates or= {}

isDigit = (value) ->
  /^\d$/.test(value)

toArray = (value) ->
  Array::slice.call(value, 0)

exports.observe = observe = (object, callback) ->
  nodes = []

  render = ->
    fragment = callback(object)
    newNodes = (node for node in fragment.childNodes)
    parent   = nodes[0] and nodes[0].parentNode

    if parent
      for newNode in newNodes
        parent.insertBefore newNode, nodes[0]

      for node in nodes
        parent.removeChild(node)

    nodes = newNodes
    fragment

  Object.observe(object, render)
  render()

exports.observeEach = observeEach = (array, callback) ->
  fragment   = document.createDocumentFragment()
  arrayNodes = []
  arrayClone = toArray(array)

  for value in array
    frag = observe(value, callback)
    arrayNodes.push((n for n in frag.childNodes))
    fragment.appendChild(frag)

  add = (index, value) ->
    frag  = observe(value, callback)
    nodes = (n for n in frag.childNodes)

    previousNode = arrayNodes[index - 1]
    previousNode = previousNode?[previousNode.length - 1]
    previousNode?.parentNode.insertBefore(frag, previousNode.nextSibling)

    arrayNodes.splice(index - 1, 0, nodes)

  remove = (index) ->
    for node in arrayNodes[index]
      node.parentNode?.removeChild(node)

    arrayNodes.splice(index, 1)

  change = ->
    removed = ([i] for item, i in arrayClone when item not in array)
    added   = ([i, item] for item, i in array when item not in arrayClone)

    remove(args...) for args in removed
    add(args...) for args in added
    arrayClone = toArray(array)

  Object.observe array, (changes) ->
    changes = (c for c in changes when isDigit(c.name))
    change() if changes.length

  fragment



