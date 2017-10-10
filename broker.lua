local module = {}
m = nil

-- Sends a simple ping to the broker
local function send_ping()  
    m:publish(config.MQTT.STATE .. "ping","id=" .. config.ID, 0, 0)
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.MQTT.TELEMETRY .. config.ID, 0, function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120, config.MQTT.LOGIN, config.MQTT.PASSWORD)
    -- register message callback beforehand
    m:on("message", app.onMessage)
    -- Connect to broker
    m:connect(config.MQTT.HOST, config.MQTT.PORT, 0, function(client) 
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 30000, 1, send_ping)
    end) 

end

local function mqtt_stop()
    m:close()
end

function module.start()  
  mqtt_start()
end

function module.stop()
  mqtt_stop()
end

return module
