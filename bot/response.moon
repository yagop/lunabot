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

  -- Kicks user from Channel or Chat
  kick: (peerId) =>
    if @message.to.__class == Chat
      @robot.logger\info "Kicking #{peerId} from chat #{@envelope.group.id}"
      @robot.adapter\chatKick @envelope.group.id, peerId, callback, callbackData
    else if @message.to.__class == Channel
      @robot.logger\info "Kicking #{peerId} from channel #{@envelope.group.id}"
      @robot.adapter\channelKick @envelope.group.id, peerId, callback, callbackData
    else
      @robot.logger\info "Kick not implemented for class #{@message.to.__class.__name}"
      assert false

  --- Returns true if peerId is admin of a channel or chat.
  -- A user is group admin if he invited the bot or is the bot itself
  isBotAdmin: (peerId,  callback, callbackData) =>
    @robot.logger\info "Checking if #{peerId} isBotAdmin"
    -- The bot itself
    if peerId == @robot.adapter.ourId and false
      @robot.logger\info "Bot is admin of himself."
      callback callbackData, true, nil if extra.callback
    else
      if @message.to.__class == Chat -- Check if bot was invited by that member
        @robot.logger\info "isBotAdmin Chat"
        @robot.adapter\chatInfo @envelope.group.id, (extra, ok, info) ->
            if ok
              -- Find bot to get the inviter's peer_id
              bot = nil
              for _, member in pairs info.members
                bot = member if member.peer_id == @robot.adapter.ourId
              if bot and bot.inviter -- Check if bot was invited by someone
                inviterPeerId = bot.inviter.peer_id
                if inviterPeerId == extra.peerId -- Bot inviter is provided peerId
                  @robot.logger\info "Bot was invited by #{inviterPeerId}"
                  extra.callback extra.callbackData, ok, true if extra.callback
                else
                  @robot.logger\info "Bot wasn't invited by #{inviterPeerId}"
                  extra.callback extra.callbackData, ok, false if extra.callback
              else
                @robot.logger\info "Bot not found or wasen't invited"
                extra.callback extra.callbackData, ok, false if extra.callback
            else
              @robot.logger\error "chatInfo failed!"
              extra.callback extra.callbackData, ok, nil if extra.callback,
          {:callback, :callbackData, :peerId}
      else if @message.to.__class == Channel
        -- Get channel admins
        @robot.logger\info "isBotAdmin Channel"
        @robot.adapter\channelAdmins @envelope.group.id, (extra, ok, admins) ->
            if not ok -- Error ...
              @robot.logger\info "Can't get Channel #{@envelope.group.id} admins"
              extra.callback extra.callbackData, ok, nil if extra.callback
            else
              found = false
              for _, admin in pairs admins
                if admin.peer_id == extra.peerId
                  found = true
                  @robot.logger\info "#{extra.peerId} is #{@envelope.group.id} admin"
              if not found
                @robot.logger\info "#{extra.peerId} isn't #{@envelope.group.id} admin"
              extra.callback extra.callbackData, ok, found if extra.callback,
          {:callback, :callbackData, :peerId}
      else
        @robot.logger\error "Unsuported message to class in isBotAdmin"
        assert false
