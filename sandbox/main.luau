--!strict
const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local scale = 100
local seed = 123456

local base_noise = monet.noise.fractalBrownian(function(x: number, y: number): Colour4
	return monet.noise.simplex(x / scale, y / scale, seed)
end,4,2,0.5)

local warp_noise = monet.noise.fractalBrownian(function(x: number, y: number): Colour4
    return monet.noise.simplex(x / scale, y / scale, seed + 100)
end,4,2,0.5)

local layer1 = monet.noise.domainWarp(base_noise, warp_noise, 25)
local layer2 = monet.noise.domainWarp(base_noise, layer1, 50)

local image = monet.image.fromLambda(512, 512, layer2)
    :Add(monet.image.fromColour(512, 512, colour.New(0.5,0.5,0.5)))
    :HdrTonemap({Filter= "ACES",Exposure = -2})

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
