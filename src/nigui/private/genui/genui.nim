import macros, deques

proc `[]`(s: NimNode, x: Slice[int]): seq[NimNode] =
  ## slice operation for NimNodes.
  var a = x.a
  var L = x.b - a + 1
  newSeq(result, L)
  for i in 0.. <L: result[i] = s[i + a]

proc high(s: NimNode):int =
  ## high operation for NimNodes
  s.len-1

type ParsedWidget = ref object
  ## Object that holds all the required information about a widget as learned from parsing the input code
  pureCode: NimNode
  name: string
  dotCalls: seq[NimNode]
  initParameters: seq[NimNode]
  children: seq[ParsedWidget]
  parent: ParsedWidget
  generatedSym: NimNode

proc parseNode(node: NimNode): ParsedWidget
proc parseChildren(p: ParsedWidget, stmtlist:NimNode): seq[ParsedWidget] =
  result = @[]
  for child in stmtList:
    var node = parseNode(child)
    node.parent = p
    result.add node

proc parseNode(node: NimNode): ParsedWidget =
  new result
  var
    toParse = initDeque[NimNode]()
    cnode = node
  if cnode.kind == nnkIdent:
    result.name = $cnode.ident
    cnode = nil
  template checkName() =
    if cnode[0].kind == nnkIdent:
      result.name = $cnode[0].ident
    else:
      toParse.addFirst cnode[0]
  while cnode != nil:
    echo "Parsing: " & $cnode.kind
    if cnode.len != 0 and cnode[cnode.high].kind == nnkStmtList:
      toParse.addFirst cnode[cnode.high]
      cnode.del cnode.high
    case cnode.kind:
    of nnkCurlyExpr:
      result.pureCode = cnode[1]
      checkName()
    of nnkCurly:
      result.pureCode = cnode[0]
    of nnkBracketExpr:
      result.dotCalls = cnode[1..cnode.high]
      checkName()
    of nnkBracket:
      result.dotCalls = cnode[0 .. ^1]
    of nnkPar:
      result.initParameters = cnode[0 .. ^1]
    of nnkCall:
      result.initParameters = cnode[1..cnode.high]
      checkName()
    of nnkCommand:
      if cnode[cnode.high].kind == nnkIdent:
        result.name = $cnode[cnode.high].ident
        for i in countdown(cnode.high-1, 0):
          toParse.addFirst cnode[i]
      else:
        for i in countdown(cnode.high, 0):
          toParse.addFirst cnode[i]
    of nnkStmtList:
      result.children = result.parseChildren cnode
    else:
      for child in countdown(cnode.high, 0):
        toParse.addFirst cnode[child]
    if toParse.len != 0:
      cnode = toParse.peekFirst()
      discard toParse.popFirst()
    else:
      cnode = nil
  echo "Returning"

proc createWidget(widget: ParsedWidget, parent: NimNode = nil): NimNode =
  result = newStmtList()
  echo "Hello"
  echo widget.name
  var call = newCall("new" & widget.name)
  for param in widget.initParameters:
    call.add param
  widget.generatedSym = genSym(nskVar)
  result.add nnkVarSection.newTree(
    nnkIdentDefs.newTree(
      widget.generatedSym,
      newEmptyNode(),
      call
    )
  )
  proc replacePlaceholder(n: NimNode): bool =
    for i in 0 .. n.high:
      let child = n[i]
      if child.kind == nnkPrefix and child[0].kind == nnkIdent and child[1].kind == nnkIdent and
        child[0].ident == !"@" and (child[1].ident == !"result" or child[1].ident == !"r"):
          n[i] = widget.generatedSym
          return true
      let done = child.replacePlaceholder()
      if done:
        return true

  for dotCall in widget.dotCalls:
    let call =  "@result." & dotCall.repr
    echo call
    let callExpr = call.parseExpr
    discard replacePlaceholder(callExpr)
    result.add callExpr

  if widget.pureCode != nil:
    if widget.pureCode.kind == nnkStrLit:
      widget.pureCode = widget.pureCode.strVal.parseExpr
    widget.pureCode = widget.pureCode.repr.parseExpr
    discard replacePlaceholder(widget.pureCode)
    result.add(widget.pureCode)

  for child in widget.children:
    for node in createWidget(child, widget.generatedSym):
      result.add node

  if parent != nil:
    result.add newCall("add", parent, widget.generatedSym)

macro genui*(widgetCode: untyped): untyped =
  ## Macro to create NiGui code from the genui syntax (see documentation)
  echo widgetCode.treeRepr
  let parsed = nil.parseChildren(widgetCode)
  result = newStmtList()
  for widget in parsed:
    result.add createWidget(widget)
  echo result.repr

macro addElements*(parent:untyped, widgetCode: untyped): untyped=
  ## Macro to create NiGui code from the genui syntax (see documentation) and create add calls for the resulting widgets for the given parent
  echo widgetCode.treeRepr
  let parsed = nil.parseChildren(widgetCode)
  result = newStmtList()
  for widget in parsed:
    result.add createWidget(widget, parent)
  echo result.repr

