const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local scale = 70
local seed = 123456

local base_noise = function(x: number, y: number): Colour4
	local value = monet.noise.simplex(x / scale, y / scale, seed).Red

	return colour.New(value, value, value)
end

local noise_fn = monet.noise.fractalBrownian(base_noise, 5, 2, 0.5)

local image = monet.image.fromLambda(512, 512, noise_fn):Add(
	monet.image.fromColour(512, 512, colour.New(0.5, 0.5, 0.5))
):HdrTonemap({ Filter = "ACES", Exposure = -2 })

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
