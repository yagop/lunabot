lfs = require "lfs"

class Plugins
  new: (@robot) =>
    @plugins = {}

  load: () =>
    @robot.logger\info "Loading plugins..."
    for file in lfs.dir "plugins"
      @robot.logger\debug "Found file: #{file}"
      -- Only match files ending with .moon or .lua
      ext = file\match "(.*)%.moon$" or file\match "(.*%).lua$"
      if ext
        @robot.logger\info "Loading plugin: #{ext}"
        plugin = require "plugins.#{ext}"
        plugin.run @robot
        table.insert @plugins, plugin
