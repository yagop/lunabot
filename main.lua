package.path = package.path .. ';luarocks/share/lua/5.2/?.lua'
  ..';luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';luarocks/lib/lua/5.2/?.so'

-- MoonScript Loader
local moonscript = require("moonscript.base")
local errors = require("moonscript.errors")
local util = require("moonscript.util")

local APP = 'bot/robot.moon'

local print_err = function(...)
  local msg = table.concat((function(...)
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = {
      ...
    }
    for _index_0 = 1, #_list_0 do
      local v = _list_0[_index_0]
      _accum_0[_len_0] = tostring(v)
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)(...), "\t")
  return io.stderr:write(msg .. "\n")
end

local moonscript_chunk, lua_parse_error
local passed, err = pcall(function()
  moonscript_chunk, lua_parse_error = moonscript.loadfile(APP, {
    implicitly_return_root = true
  })
end)
if not (passed) then
  print(err)
elseif not (moonscript_chunk) then
  if lua_parse_error then
    print_err(lua_parse_error)
  else
    print_err("Can't file file: " .. tostring(script_fname))
  end
else
  local run_chunk
  run_chunk = function ()
    moonscript.insert_loader()
    moonscript_chunk()
  end
  xpcall(run_chunk, function(_err)
    err = _err
    trace = debug.traceback("", 2)
  end)
  if err then
    local truncated = errors.truncate_traceback(util.trim(trace))
    local rewritten = errors.rewrite_traceback(truncated, err)
    if rewritten then
      return print_err(rewritten)
    else
      return print_err(table.concat({
        err,
        util.trim(trace)
      }, "\n"))
    end
  end
end
