logging = require "logging"
Listener = require "bot.listener"
Response = require "bot.response"
adapter = require "bot.adapter"
Plugins = require "bot.plugins"
Peers = require "bot.peers"
Redis = require "bot.redis"
import p from require "moon"

class Robot
  new: (@options) =>
    @listeners = {}
    logFile = "logs/log.txt"
    @logger = logging.new((level, message) =>
      print message)
    @logger\info "Robot started"
    @redis = (Redis @).client
    @adapter = adapter.run @
    @plugins = Plugins @
    @plugins\load!

  onText: (pattern, fromPeerType, toPeerType, callback) =>
    text = "New text matcher #{pattern} #{fromPeerType.__class.__name}"
    text ..= " #{toPeerType.__class.__name}"
    @logger\info text
    matcher = (msg) ->
      if msg.type == "text"
        print "Matched msg.type"
        if msg\isFrom fromPeerType
          print "Matched fromPeerType"
          if msg\isTo toPeerType
            print "Matched toPeerType"
            matches = {msg.text\match pattern}
            if next matches
              return matches
    listener = Listener @, matcher, callback
    table.insert @listeners, listener

  onTextReply: (pattern, fromPeerType, toPeerType, callback) =>
    text = "New text_reply matcher #{pattern} #{fromPeerType.__class.__name}"
    text ..= " #{toPeerType.__class.__name}"
    @logger\info text
    matcher = (msg) ->
      if msg.type == "text_reply"
        print "Matched msg.type"
        if msg\isFrom fromPeerType
          print "Matched fromPeerType"
          if msg\isTo toPeerType
            print "Matched toPeerType"
            matches = {msg.text\match pattern}
            if next matches
              return matches

    listener = Listener @, matcher, callback
    table.insert @listeners, listener

  receive: (msg) =>
    @logger\info "Robot received new message:"
    p msg
    response = Response @, msg
    for k, listener in pairs @listeners do
      print "Checking listener #{k}"
      listener\call response

Robot!
