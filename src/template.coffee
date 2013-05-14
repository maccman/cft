sanitize = (value) ->
  if value and value.ecoSafe
    value
  else if value?
    escape value
  else
    ""

safe = (value = '') ->
  if value and value.ecoSafe
    value
  else
    result = new String(value)
    result.ecoSafe = true
    result

escape = (value) ->
    ("" + value).replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\x22/g, "&quot;")

makeFragment = (value, element) ->
  element or= document.createElement('div')

  range = document.createRange()
  range.setStart(element, 0)
  range.collapse(false)
  range.createContextualFragment(value)