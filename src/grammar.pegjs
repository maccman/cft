start = NODES

NODES = (c:NODE _ { return c; })*
NODE  = node:ECONode / HTMLNode

// ECO

ECO      = ECONodes
ECONodes = (c:ECONode _ { return c; })*
ECONode  = ECOLiteral / ECOEND / ECOEscapedContent / ECOContent / ECOExpression

// <%% / %%>
ECOLiteral = ECOLiteralLeft / ECOLiteralRight
ECOLiteralLeft  = '<%%' { return { type: 'eco', tag: 'leftLiteral' } }
ECOLiteralRight = '%%>' { return { type: 'eco', tag: 'rightLiteral' } }

// <% end %>
ECOEND =
  ECOOpen _ 'end' _ ECOClose
  { return { type: 'eco', tag: 'end' } }

// <% %>
ECOExpression =
  ECOOpen _ cont:ECOTagChars? indent:ECOIndent _ ECOClose
  { return { type: 'eco', tag: 'expression', content: cont, indent: indent }}

// <%= %>
ECOEscapedContent =
  ECOOpen '=' _ cont:ECOTagChars _ ECOClose
  { return { type: 'eco', tag: 'escapedContent', content: cont }}

// <%- %>
ECOContent =
  ECOOpen '-' _ cont:ECOTagChars _ ECOClose
  { return { type: 'eco', tag: 'content', content: cont }}

// ECO Utilities

ECOTagChar = !(":"? _ "%>") c:char { return c; }
ECOTagChars = c:(ECOTagChar+) { return c.join(''); }

ECOIndent = indent:':'? { return !!indent }
ECOOpen   = '<%'
ECOClose  = '%>'

// HTML

HTML = HTMLNodes

HTMLNodes = (c:HTMLNode _ { return c; })*
HTMLNode = HTMLDoctype / HTMLCDATA / HTMLComment / HTMLScript / HTMLStyle / HTMLElement / HTMLText

HTMLAttribute "element attribute"
  = t:HTMLTag _ '=' _ v:HTMLValue _ { return { attr: t, value: v } }
  / t:HTMLTag v:(HTMLValueDoubleQuoted / HTMLValueQuoted) { return { attr: t, value: v } }
  / t:HTMLTag _ { return { attr: t }}
  / ECONode

// CDATA

HTMLCDATA "CDATA section"
  = "<![CDATA[" cont:HTMLCDATAChars "]]>"
  { return { type: 'cdata', 'content': cont  } }

HTMLCDATAChar = !("]]>") c:char { return c; }
HTMLCDATAChars = c:(HTMLCDATAChar+) { return c.join(''); }

// Comment

HTMLComment "comment"
  = HTMLElementOpenDelim '!--' _ chars:(HTMLCommentSTChar*) _ '--' HTMLElementCloseDelim
  { return { type: 'comment', content: chars.join('') } }

HTMLCommentSTChar = !("-->") c:char { return c; }

// Doctype

HTMLDoctype "doctype"
  = HTMLElementOpenDelim "!" "DOCTYPE"i _ cont:HTMLNodeChars _ HTMLElementCloseDelim
{ return { type: 'doctype', content: cont } }

// Element

HTMLElement =  HTMLElementInline / HTMLElementOpen / HTMLElementClose

HTMLElementInline "inline element"
  = HTMLElementOpenDelim _ t:HTMLTag _ attrs:HTMLAttribute* _ '/' _ HTMLElementCloseDelim
  { return { type: 'element', tag : t, variant: 'inline', attributes: attrs } }
HTMLElementOpen "new element"
  = HTMLElementOpenDelim _ t:HTMLTag _ attrs:HTMLAttribute* _ HTMLElementCloseDelim
  { return { type: 'element', tag : t, variant: 'open', attributes: attrs } }
HTMLElementOpenDelim = '<'
HTMLElementClose "end of element"
  = HTMLElementOpenDelim _ '/' _ t:HTMLTag _ HTMLElementCloseDelim
  { return { type: 'element', tag : t, variant: 'close' } }
HTMLElementCloseDelim = '>'

// Script element

HTMLScript "element <script>" =
  HTMLElementOpenDelim _ 'script'i _ attrs:HTMLAttribute* _ HTMLElementCloseDelim cont:(HTMLScriptContentChars) HTMLElementOpenDelim _ '/' _ 'script'i _ HTMLElementCloseDelim
  { return { type : 'script', attributes: attrs, content: cont} }

HTMLScriptContentChar = !("</script>") c:char { return c; }
HTMLScriptContentChars = c:(HTMLScriptContentChar+) { return c.join(''); }

// Style element

HTMLStyle "element <style>" =
  HTMLElementOpenDelim _ 'style'i _ attrs:HTMLAttribute* _ HTMLElementCloseDelim cont:(HTMLContentChars) HTMLElementOpenDelim _ '/' _ 'style'i _ HTMLElementCloseDelim
  { return { type : 'style', attributes: attrs, content: cont} }

// Text

HTMLText
  = cont:(HTMLContentChars)+
  { return { type: 'text', content: cont }}

// HTML Utilities

HTMLContentChar = !("</" / "<") c:char { return c; }
HTMLContentChars = c:(HTMLContentChar+) { return c.join(''); }

HTMLTag = chars:(HTMLTagChars)+ { return chars.join(''); }
HTMLTagChars = [a-zA-Z0-9\-\:_]

HTMLNodeChar = !(">") c:char { return c; }
HTMLNodeChars = c:(HTMLNodeChar+) { return c.join(''); }

HTMLValue = HTMLValueDoubleQuoted / HTMLValueQuoted / HTMLValueNoQuoted
HTMLValueDoubleQuoted = '"' _ '"' { return ''; } / '"' chars:(HTMLValueDoubleQuotedChar+) '"' ','? { return chars.join(''); }
HTMLValueDoubleQuotedChar = !('"') c:char { return c; }
HTMLValueQuoted = "'" _ "'" { return ''; } / "'" chars:(HTMLValueQuotedChar+) "'" ','? { return chars.join(''); }
HTMLValueQuotedChar = !("'") c:char { return c; }
HTMLValueNoQuoted = chars:(HTMLValueNoQuotedChar+) { return chars.join(''); }
HTMLValueNoQuotedChar = !('>' / whitespace) c:char { return c; }

// Utilities

_ "whitespaces"
  = whitespace*

whitespace
  = [ \t\n\r]

hexDigit
  = [0-9a-fA-F]

char "character"
  = "\\u" h1:hexDigit h2:hexDigit h3:hexDigit h4:hexDigit {
      return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));
    }
  / [\x21-\x7E\x80-\xFF]
  / whitespace