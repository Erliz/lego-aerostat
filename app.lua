local module = {}
local fly_count = 0
local function onConfigMessagge(client, data)

end

local function onMessage(client, topic, data)
  print("Recieve message in topic `" .. topic .. "`:" )
  print(data)
  if broker.getConfigTopic() == topic then
    onConfigMessagge(client, data)
  else
    if data ~= nil then
      if tonumber(data) ~= nil then
        stepper.moveTo(tonumber(data))
      else
        if data == 'calibrate' then
          stepper.calibrate()
        elseif data == 'fly' then
          module.fly()
        elseif data == 'stop' then
          module.restart()
        elseif data == 'restart' then
          module.restart()
        end
      end
    end
  end
end

local function onError()
  module.fly()
end

function module.fly()
  fly_count = fly_count + 1
  print("Fly count: " .. fly_count)
  -- dumn recursion
  stepper.moveTo(config.APP.MAX_POINT, function()
    tmr.alarm(2, config.APP.POINT_REST_SEC, tmr.ALARM_SINGLE, function()
      stepper.moveTo(config.APP.ZERO_POINT, function()
        tmr.alarm(2, config.APP.POINT_REST_SEC, tmr.ALARM_SINGLE, module.fly)
      end)
    end)
  end)
end

function module.restart()
node.restart()
end

function module.start()
stepper.start()
broker.start(onMessage, onError)
print("Successfully init application")
end

return module
