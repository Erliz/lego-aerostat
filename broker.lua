local module = {}
m = nil

local function sendPing()
  m:publish(config.MQTT.STATE .. "ping", "id=" .. config.ID, 0, 0)
end

local function registerMyself()
  print(module.getTelmetryTopic())
  m:subscribe(module.getTelmetryTopic(), 0, function(conn)
    print("Successfully subscribed to data endpoint " .. module.getTelmetryTopic())
  end)
  print(module.getConfigTopic())
  m:subscribe(module.getConfigTopic(), 0, function(conn)
    print("Successfully subscribed to data endpoint " .. module.getConfigTopic())
  end)
end

function module.start(callback, onError)
  m = mqtt.Client(config.ID, 120, config.MQTT.LOGIN, config.MQTT.PASSWORD)
  m:on("message", callback)
  m:connect(config.MQTT.HOST, config.MQTT.PORT, 0, function(client)
    registerMyself()
    tmr.stop(6)
    sendPing()
    tmr.alarm(6, 30000, 1, sendPing)
  end,
  function(client, reason)
    print("Faild to connect to mqtt broker with reason: " .. reason)
    if (onError) then
        onError()
    end
  end)
end

function module.stop()
  m:close()
end

function module.getTelmetryTopic()
  return config.MQTT.TELEMETRY .. config.ID
end

function module.getConfigTopic()
  return config.MQTT.CONFIG .. config.ID
end

return module
