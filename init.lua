config = require("config")
network = require("network")
broker = require("broker")
stepper = require("stepper")
app = require("app")

network.start(function()
  app.start()
end)
