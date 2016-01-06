import Peer, User, Group, Chat, Channel from require "bot.peers"
Message = require "bot.message"
import p from require "moon"

class Adapter
  new: (@robot) =>
    @ourId = nil

  send: (peer, string, callback=ok_cb, callbackData=false) =>
    @robot.logger\info "Sending '#{string}' to #{peer.id}"
    send_msg peer.id, string, callback, callbackData

  sendPhoto: (envelope, file) =>
  sendVideo: (envelope, file) =>
  sendFile: (envelope, file) =>
  sendAudio: (envelope, file) =>
  reply: (envelope, string) =>
  topic: (envelope, string) =>
  close: =>
  -- Get members from peer
  members: (peer, callback, callbackData) =>
    if peer.__class == Chat
      @robot.logger\info "Calling chat_info with id #{peer.id}"
      chat_info peer.id, (extra, ok, data) ->
          if not ok
            callback extra, false, nil
          else
            users = {}
            for k, user in pairs data.members
              user = User user.id, user.peer_id, user.access_hash,
                user.first_name, user.last_name, user.print_name, user.username
              table.insert users, user
            callback extra, true, users,
        callbackData
    elseif peer.__class == Channel
      @robot.logger\info "Calling channel_get_users with id #{peer.id}"
      channel_get_users peer.id, (extra, ok, data) ->
          if not ok
            callback extra, false, nil
          else
            users = {}
            for k, user in pairs data
              user = User user.id, user.peer_id, user.access_hash,
                user.first_name, user.last_name, user.print_name, user.username
              table.insert users, user
            callback extra, true, users,
        callbackData
    else
      assert false

  -- Retrieve a message
  message: (messageId, callback, extra) =>
    get_message messageId, callback, extra

  receive: (msg) =>
    newUser = (tgUser)  ->
      User tgUser.id, tgUser.peer_id, tgUser.access_hash, tgUser.first_name,
        tgUser.last_name, tgUser.print_name, tgUser.username

    newChat = (tgChat)  ->
      Chat tgChat.id, tgChat.peer_id, tgChat.title, tgChat.print_name

    newChannel = (tgChannel)  ->
      Channel tgChannel.id, tgChannel.peer_id, tgChannel.title,
        tgChannel.print_name

    newPeer = (tgPeer) ->
      tgPeer.type = tgPeer.type or tgPeer.peer_type
      print tgPeer.type
      peer = if tgPeer.type == "user"
        peer = newUser tgPeer
      elseif tgPeer.type == "chat"
        peer = newChat tgPeer
      elseif tgPeer.type == "channel"
        peer = newChannel tgPeer
      assert(peer != nil)
      peer

    @robot.logger\info "New message in adapter"
    if msg.text
      @robot.logger\info "A text message!"
      @robot.logger\info msg
      fromPeer = newPeer msg.from
      @robot.logger\info "Message from #{fromPeer.id}"
      toPeer = newPeer msg.to
      @robot.logger\info "Message to #{toPeer.id}"
      message = if msg.reply_id
        message = Message msg.id, "text_reply", fromPeer, toPeer, msg.date, msg
      else
        message = Message msg.id, "text", fromPeer, toPeer, msg.date, msg
      @robot\receive message


run = (robot) ->
  -- Global functions
  export on_our_id, on_binlog_replay_end, on_get_difference_end
  export on_msg_receive, on_user_update, on_chat_update, cron
  export on_secret_chat_update, ok_cb

  adapter = Adapter robot
  on_our_id = (ourId) ->
    adapter.ourId = ourId
    print "Our telegram ID: #{ourId}"

  on_binlog_replay_end = ->
    print 'on_binlog_replay_end'

  on_get_difference_end = ->
    print 'on_get_difference_end'

  on_msg_receive = (msg) ->
    adapter\receive msg

  on_user_update = (msg) ->
    print 'on_user_update'
  on_chat_update = (msg) ->
    print 'on_chat_update'
  on_secret_chat_update = () ->
    print 'on_secret_chat_update'
  cron = () ->
    print 'cron'
  ok_cb = () ->

  adapter

{:run}
