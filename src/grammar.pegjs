start = NODES

NODES = (c:NODE _ { return c; })*
NODE  = CFTTag / HTMLNode

// CFT

CFT     = CFTTags
CFTTags = (c:CFTTag _ { return c; })*
CFTTag  = CFTLiteral / CFTEND / CFTEscapedContent / CFTContent / CFTExpression

// <%% / %%>
CFTLiteral = CFTLiteralLeft / CFTLiteralRight
CFTLiteralLeft  = '<%%' { return { cft: 'literal', type: 'left' } }
CFTLiteralRight = '%%>' { return { cft: 'literal', type: 'right' } }

// <% end %>
CFTEND =
  CFTOpen _ 'end' _ CFTClose
  { return { cft: 'end' } }

// <% %>
CFTExpression =
  CFTOpen _ cont:CFTTagChars? indent:CFTIndent _ CFTClose
  { return { cft: 'expression', content: cont, indent: indent }}

// <%= %>
CFTEscapedContent =
  CFTOpen '=' _ cont:CFTTagChars _ CFTClose
  { return { cft: 'escapedContent', content: cont }}

// <%- %>
CFTContent =
  CFTOpen '-' _ cont:CFTTagChars _ CFTClose
  { return { cft: 'content', content: cont }}

// CFT Utilities

CFTTagChar = !(":"? _ "%>") c:char { return c; }
CFTTagChars = c:(CFTTagChar+) { return c.join(''); }

CFTIndent = indent:':'? { return !!indent }
CFTOpen   = '<%'
CFTClose  = '%>'

// HTML

HTML = HTMLNodes

HTMLNodes = (c:HTMLNode _ { return c; })*
HTMLNode = HTMLDoctype / HTMLCDATA / HTMLComment / HTMLScript / HTMLStyle / HTMLElement / HTMLContentChars

HTMLAttribute "element attribute"
  = t:HTMLTag _ '=' _ v:HTMLValue _ { return { attr: t, value: v } }
  / t:HTMLTag v:(HTMLValueDoubleQuoted / HTMLValueQuoted) { return { attr: t, value: v } } // when missing '='
  / t:HTMLTag _ { return {tag: t }}

// CDATA

HTMLCDATA "CDATA section" = "<![CDATA[" cont:HTMLCDATAChars "]]>" { return { tag: 'CDATA', 'content': cont  } }
HTMLCDATAChar = !("]]>") c:char { return c; }
HTMLCDATAChars = c:(HTMLCDATAChar+) { return c.join(''); }

// Comment

HTMLComment "comment"
  = HTMLElementOpenDelim '!--' _ chars:(HTMLCommentSTChar*) _ '--' HTMLElementCloseDelim
  { return { comment: chars.join('') } }

HTMLCommentSTChar = !("-->") c:char { return c; }

HTMLContentChar = !("</" / "<") c:char { return c; }
HTMLContentChars = c:(HTMLContentChar+) { return c.join(''); }

// Doctype

HTMLDoctype "doctype"
  = HTMLElementOpenDelim "!" "DOCTYPE"i _ cont:HTMLNodeChars _ HTMLElementCloseDelim
{ return { doctype : cont } }

// Element

HTMLElement =  HTMLElementInline / HTMLElementOpen / HTMLElementClose

HTMLElementInline "inline element"
  = HTMLElementOpenDelim _ t:HTMLTag _ attrs:HTMLAttribute* _ '/' _ HTMLElementCloseDelim
  { return { tag : t, type: 'inline', attributes: attrs } }
HTMLElementOpen "new element"
  = HTMLElementOpenDelim _ t:HTMLTag _ attrs:HTMLAttribute* _ HTMLElementCloseDelim
  { return { tag : t, type: 'open', attributes: attrs } }
HTMLElementOpenDelim = '<'
HTMLElementClose "end of element"
  = HTMLElementOpenDelim _ '/' _ t:HTMLTag _ HTMLElementCloseDelim
  { return { tag : t, type: 'close' } }
HTMLElementCloseDelim = '>'

// Script element

HTMLScript "element <script>" = HTMLElementOpenDelim _ 'script'i _ attrs:HTMLAttribute* _ HTMLElementCloseDelim cont:(HTMLScriptContentChars) HTMLElementOpenDelim _ '/' _ 'script'i _ HTMLElementCloseDelim
{ return { tag : 'script', attributes: attrs, content: cont} }

HTMLScriptContentChar = !("</script>") c:char { return c; }
HTMLScriptContentChars = c:(HTMLScriptContentChar+) { return c.join(''); }

// Style element

HTMLStyle "element <style>" =  HTMLElementOpenDelim _ 'style'i _ attrs:HTMLAttribute* _ HTMLElementCloseDelim cont:(HTMLContentChars) HTMLElementOpenDelim _ '/' _ 'style'i _ HTMLElementCloseDelim
{ return { tag : 'style', attributes: attrs, content: cont} }

// HTML Utilities

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