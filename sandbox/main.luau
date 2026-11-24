--!strict

const monet = require("@monet")
local colour = require("@vara/colour")
local fs = require("@vara/fs")

local base = colour.FromHex("6495ED")
local scale = 0.05

local image = monet.image.fromLambda(512, 512, function(x: number, y: number): Colour4
    local value = math.map(math.noise(x * scale,y * scale), -1,1,0,1)

    return base * colour.New(value, value, value)
end)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))