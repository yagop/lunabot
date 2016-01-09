import Peer, User, Chat, Channel, Group from require "bot.peers"
import p from require "moon"

run = (robot) ->
  robot\onTextReply "^/kick$", User, Group, (response) ->
    -- If message is from an admin
    response\isBotAdmin response.message.from.peerId, (response, ok, isAdmin) ->
        if ok and isAdmin
          replyId = response.message.replyId
          response.robot.logger\info "replyId: #{replyId}"
          response.robot.adapter\message replyId, (response, ok, message) ->
              userId = message.from.id
              response.robot.logger\info "Kick #{userId}"
              response\kick userId,
            response,
      response
{:run}
