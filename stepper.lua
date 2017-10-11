local module = {}

local channel = config.STEPPER.CHANNEL
local inAction = false

function module.start()
  switec.setup(
    channel,
    config.STEPPER.PIN1,
    config.STEPPER.PIN2,
    config.STEPPER.PIN3,
    config.STEPPER.PIN4,
    config.STEPPER.MAX_DEGREE
  )
  print("Successfully init stepper")
end

function module.stop()
  switec.close(channel)
  inAction = false
end

function module.moveTo(position, callback)
  if inAction then
    print("ignore")
    return
  end

  print("go to pos" .. position)
  inAction = true
  switec.moveto(channel, position, function()
    inAction = false
    if (callback) then
      callback()
    end
  end)
end

function module.calibrate(callback)
  module.moveTo(-1000, function()
    switec.reset(0)
    if (callback) then
      callback()
    end
  end)
end

function module.printPosition()
  print(switec.getpos(channel))
end

return module
