local module = {}

function module.onMessage(client, topic, data) 
    print("Recieve message in topic `" .. topic .. "`:" ) 
    print(data)
    if data ~= nil then
        if data == 'calibrate' then
            stepper.calibrate()
        else
            stepper.moveTo(1000, function()
                stepper.moveTo(0)
            end)
        end
    end
end

function module.start()
    broker.start()
    stepper.start()
    print("Successfully init application")
end

return module
