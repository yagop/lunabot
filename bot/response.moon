import User, Channel, Chat from require "bot.peers"
import p from require "moon"

class Response
  new: (@robot, @message) =>
    @envelope =
      from: @message.from
      to: @message.to

    if @message.to.__class == Channel or @message.to.__class == Chat
      @envelope.group = @message.to

    groupId = @envelope.group and @envelope.group.id
    @robot.logger\info "Created new response:
      from: #{@message.from.id}
      to: #{@message.to.id}
      group: #{groupId}"

  -- Public: Posts a message back to the source
  send: (text, callback, callbackData) =>
    -- If message goes direcly to us, send to user. Else send to group (chat)
    peer = if @message.to.__class == User
      @message.from
    else -- Channel or Chat
      @message.to
    @robot.logger\info "The response goes to a #{peer.__class.__name}"
    @robot.adapter\send peer, text, callback, callbackData
