--!strict

const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local base = colour.FromHex("6495ED")

local scale = 100
local seed = 123456

local noise_fn = function(x: number,y: number)
    local value = math.noise(x / scale,y / scale,seed)

    return colour.New(value,value,value)
end

local image = monet.image.fromLambda(512, 512, noise_fn)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
