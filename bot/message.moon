class Message
  @mapKeys =
    reply_id: "replyId"
  
  -- @id: Unique ID of the Message
  -- @type: Type of msg: `text`, `media`, `action` or `service`
  -- @from: Peer
  -- @to: Peer
  -- @date: UNIX timestamp
  -- @options: Aditional fields
  new: (@id, @type, @from, @to, @date, options) =>
    for key, value in pairs options
      key = @@mapKeys[key] or key
      if not @[key]
        @[key] = value
  
  isFrom: (peerClass) =>
    print "#{@to.__class.__name} == #{peerClass.__name}"
    isInstanceAncestorOrSelfClass = (c, C) ->
      matches = if c == C
          matches = true
        elseif c.__parent != nil
          matches = isInstanceAncestorOrSelfClass(c.__parent, C)
        else
          matches = false
      matches
    isInstanceAncestorOrSelfClass @from.__class, peerClass
    
    
  isTo: (peerClass) =>
    print "#{@from.__class.__name} == #{peerClass.__name}"
    isInstanceAncestorOrSelfClass = (c, C) ->
      matches = if c == C
          matches = true
        elseif c.__parent != nil
          matches = isInstanceAncestorOrSelfClass(c.__parent, C)
        else
          matches = false
      matches
    isInstanceAncestorOrSelfClass @to.__class, peerClass

Message
