--!strict
const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local scale = 150
local seed = 123456

local noise_fn = function(x: number,y: number)
    local value = math.noise(x / scale,y / scale,seed)

    return colour.New(value,value,value)
end

noise_fn = monet.noise.billow(noise_fn,4,2,0.5)

local image = monet.image.fromLambda(512, 512, noise_fn)
    :Add(monet.image.fromColour(512, 512, colour.New(0.5,0.5,0.5)))
    :HdrTonemap({Filter= "ACES",Exposure = -2})

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
