import Peer, User, Chat, Channel, Group from require "bot.peers"
import p from require "moon"

run = (robot) ->
  robot\onTextReply "^/kick$", User, Peer, (response) ->
    replyId = response.message.replyId
    response.robot.logger\info "replyId: #{replyId}"
    response.robot.adapter\message replyId, (response, ok, message) ->
        peerId = message.from.id
        response.robot.logger\info "Kick #{peerId}"
        response\kick peerId,
      response

{:run}
