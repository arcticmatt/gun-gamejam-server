local socket = require "socket"
local entities  = require("entities.s_entities")
local Player = require("entities.s_player")
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 12345)

-- replaced by entities
-- local world = {} -- the empty world-state
local data, msg_or_ip, port_or_nil
local entity, cmd, params, dt, currenttime
local previoustime = socket.gettime()

local running = true

-- TODO add dt
print "Beginning server loop."
while running do
  currenttime = socket.gettime()
  dt = currenttime - previoustime
  data, msg_or_ip, port_or_nil = udp:receivefrom()
  -- TODO: check msg_or_ip and port_or_nil
  -- TODO: broadcast update instead of sending it per request
  if data then
    -- more of these funky match paterns!
    ent_id, cmd, params = data:match("^(%S*) (%S*) (.*)")
    ent_id = tonumber(ent_id)

    print(cmd)

    if cmd == 'move' then
      print("moving", x, y)
      -- TODO: validation of inputs
  		local x, y = params:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
  		assert(x and y) -- validation is better, but asserts will serve.
  		-- don't forget, even if you matched a "number", the result is still a string!
  		-- thankfully conversion is easy in lua.
  		x, y = tonumber(x), tonumber(y)
  		-- and finally we stash it away
      entities:update(ent_id, x, y, dt)
  	elseif cmd == 'spawn' then
      print('spawn')
      local id, new_player
      repeat
        math.randomseed(os.time())
        id = math.random(99999)
      until id ~= 0 and not entities:get_entity(id)
      new_player = Player(50, 50, 32, 32, udp, msg_or_ip, port_or_nil, id)
      entities:add(id, new_player)
      print("send_spawn_info call")
      new_player:send_spawn_info()
  	elseif cmd == 'update' then
      entities:send_at_info()
  	elseif cmd == 'quit' then
  		running = false;
    else
      print("unrecognised command:", cmd)
    end
  elseif msg_or_ip ~= 'timeout' then
    error("Unknown network error: "..tostring(msg))
  end

  previoustime = currenttime
  socket.sleep(0.01)
end

print "Thank you."
