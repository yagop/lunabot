import p from require "moon"

class Listener
  new: (@robot, @matcher, @callback) =>

  -- Call the callback if the matcher matched.
  call: (response) =>
    print "Checking self.matcher"
    match = self.matcher response.message
    if match
      @robot.logger\info "Message matches!"
      self.callback response, match
