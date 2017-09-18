local socket = require "socket"
local entities  = require("entities.s_entities")
local Player = require("entities.s_player")
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 12345)

-- replaced by entities
-- local world = {} -- the empty world-state
local data, msg_or_ip, port_or_nil
local entity, cmd, parms

local running = true

print "Beginning server loop."
while running do
  data, msg_or_ip, port_or_nil = udp:receivefrom()
  -- TODO: check msg_or_ip and port_or_nil
  -- TODO: broadcast update instead of sending it per request
  if data then
    -- more of these funky match paterns!
    ent_id, cmd, parms = data:match("^(%S*) (%S*) (.*)")

    if not entities:get_entity(ent_id) then
      new_player = Player(0, 0, 20, 20)
      entities:add(new_player)
    end

    if cmd == 'move' then
      -- TODO: validation of inputs
  		local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
  		assert(x and y) -- validation is better, but asserts will serve.
  		-- don't forget, even if you matched a "number", the result is still a string!
  		-- thankfully conversion is easy in lua.
  		x, y = tonumber(x), tonumber(y)
  		-- and finally we stash it away
      print("moving", x, y)
      entities:update(ent_id, x, y)
  	elseif cmd == 'at' then
  		local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
  		assert(x and y) -- validation is better, but asserts will serve.
  		x, y = tonumber(x), tonumber(y)
      entities:update(ent_id, x, y)
  	elseif cmd == 'update' then
      entities:send_info()
  	elseif cmd == 'quit' then
  		running = false;
    else
      print("unrecognised command:", cmd)
    end
  elseif msg_or_ip ~= 'timeout' then
    error("Unknown network error: "..tostring(msg))
  end

  socket.sleep(0.01)
end

print "Thank you."
