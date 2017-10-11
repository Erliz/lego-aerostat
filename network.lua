local module = {}

local function wifi_wait_ip(callback)
  if wifi.sta.getip() == nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(1)
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")
    callback()
  end
end

local function wifi_start(list_aps, callback)
  if list_aps then
    for key, value in pairs(list_aps) do
      if config.SSID and config.SSID[key] then
        wifi.setmode(wifi.STATION);
        wifi.sta.config(key, config.SSID[key])
        wifi.sta.connect()
        print("Connecting to " .. key .. " ...")
        --config.SSID = nil  -- can save memory
        tmr.alarm(1, 2500, 1, function()
          wifi_wait_ip(callback)
        end)
      end
    end
  else
    print("Error getting AP list")
  end
end

function module.start(callback)
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi.sta.getap(function(list_aps)
    wifi_start(list_aps, callback)
  end)
end

return module
