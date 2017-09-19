local socket = require("socket")
local ents = require("entities.s_ents")
local Player = require("entities.s_player")
local udp = socket.udp()

udp:settimeout(0)
-- udp:setoption('broadcast', true)
udp:setsockname('192.168.1.12', 12345)
udp:setpeername('192.168.1.255', 12345)

local data, msg_or_ip, port_or_nil, cmd, params, dt, current_time
local broadcast_interval = 0.1
local previous_time = socket.gettime()
local previous_broadcast = socket.gettime()

-- TODO add dt
print "Beginning server loop."
while true do
  current_time = socket.gettime()
  dt = current_time - previous_time
  data, msg_or_ip, port_or_nil = udp:receive()
  print(data, msg_or_ip, port_or_nil)
  -- TODO: check msg_or_ip and port_or_nil
  -- TODO: broadcast update instead of sending it per request
  if data then
    -- more of these funky match paterns!
    ent_id, cmd, params = data:match("^(%S*) (%S*) (.*)")
    ent_id = tonumber(ent_id)

    print("data received...", data)

    if cmd == 'move' then
      print("moving", x, y)
      -- TODO: validation of inputs
  		local x, y = params:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
  		assert(x and y) -- validation is better, but asserts will serve.
  		-- don't forget, even if you matched a "number", the result is still a string!
  		-- thankfully conversion is easy in lua.
  		x, y = tonumber(x), tonumber(y)
  		-- and finally we stash it away
      ents:update(ent_id, x, y, dt)
  	elseif cmd == 'spawn' then
      print('spawn')
      local id, new_player
      repeat
        math.randomseed(os.time())
        id = math.random(99999)
      until id ~= 0 and not ents:get_ent(id)
      new_player = Player(50, 50, 32, 32, udp, msg_or_ip, port_or_nil, id)
      ents:add(id, new_player)
      print("send_spawn_info call")
      new_player:send_spawn_info()
  	elseif cmd == 'update' then
      ents:send_move_info()
    else
      print("unrecognised command:", cmd)
    end
  elseif msg_or_ip ~= 'timeout' then
    error("Unknown network error: "..tostring(msg))
  end

  if current_time - previous_broadcast > broadcast_interval then
    udp:send('ping')
    previous_broadcast = current_time
  end

  previous_time = current_time
  socket.sleep(0.01)
end

print "Finished server loop."
