moon = require "moon"

class Peer
  -- @id: Permanent ID (the long one)
  -- @peerId: Classic ID
  new: (@id, @peerId) =>

class User extends Peer
  new: (@id, @peerId, @accessHash, @firstName, @lastName, @printName, @username) =>
    super @id, @peerId
  printable: () =>
    text = "ID: #{@peerId}"
    if @username
      text ..= "\nUsername: @#{@username}"
    if @firstName
      text ..= "\nFirst name: #{@firstName}"
    if @lastName
      text ..= "\nLast name: #{@lastName}"
    text

class Group extends Peer
  new: (@id, @peerId) =>
    super @id, @peerId

class Chat extends Group
  new: (@id, @peerId, @title, @printName) =>
    super @id, @peerId

class Channel extends Group
  new: (@id, @peerId, @title, @printName, @adminsCount, @kickedCount, @participantsCount, @membersNum) =>
    super @id, @peerId

{:Peer, :User, :Group, :Chat, :Channel}
