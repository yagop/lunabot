import Peer, User, Chat, Channel, Group from require "bot.peers"
import p from require "moon"

run = (robot, response) ->
  robot\onText "^/id$", User, User, (response) ->
    id = response.envelope.from.id
    response\send id

  robot\onText "^/id$", User, Chat, (response) ->
    userId = response.envelope.from.peerId
    chatId = response.envelope.to.peerId
    text = "Your ID is #{userId}
      Chat ID is #{chatId}"
    response\send text

  robot\onText "^/id$", User, Channel, (response) ->
    userId = response.envelope.from.peerId
    chatId = response.envelope.to.peerId
    text = "Your ID is #{userId}
      Channel ID is #{chatId}"
    response\send text

  robot\onText "^/ids$", User, Group, (response) ->
    chatId = response.envelope.to.peerId
    text = "Chat id is #{chatId}"
    robot.adapter\members response.envelope.to, (extra, ok, users) ->
        response = extra.response
        text = ""
        for k, user in pairs users
          text ..= "#{user\printable!}\n\n"
        response\send text,
      {:response}

  robot\onText "^/id @([%w_%-%.]+)", Peer, Peer, (response, matches) ->
    username = matches[1]
    -- TODO move to adapter
    resolve_username username, (extra, ok, user) ->
        response = extra.response
        text = if ok
          user = User user.id, user.peer_id, user.access_hash, user.first_name,
            user.last_name, user.print_name, user.username
          text = user\printable!
        else
          text = "User not found"
        response\send text,
      {:response}

  robot\onTextReply "^/id$", Peer, Peer, (response) ->
    replyId = response.message.replyId
    response.robot.adapter\message replyId, (extra, ok, message) ->
        response\send message.from.peer_id,
      {:response}

{:run}
