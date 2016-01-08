import Peer, User, Chat, Channel, Group from require "bot.peers"
import p from require "moon"

run = (robot) ->
  robot\onTextReply "^/isadmin$", User, Group, (response) ->
    replyId = response.message.replyId
    response.robot.logger\info "replyId: #{replyId}"
    response.robot.adapter\message replyId, (response, ok, message) ->
        if ok
          peerId = message.from.peer_id
          response.robot.logger\info "Is admin #{peerId}?"
          response\isBotAdmin peerId, (response, ok, isAdmin) ->
              if ok and isAdmin
                response\send "#{peerId} is admin",
            response
        else
          response.robot.logger\error message,
      response

{:run}
