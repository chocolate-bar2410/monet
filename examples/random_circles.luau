--!strict
const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local base = colour.FromOKLCH(0.7, 0.1, 300)

local image = monet.image.fromColour(512, 512, base)

local random_circle = function()
	local fill_colour = colour.FromOKLCH(0.7, 0.1, math.random(155, 270))

	local radius = math.random(15, 30)

	local position = vector.create(
		math.random(radius + 3, image.Width - 1 - (radius + 3)),
		math.random(radius + 3, image.Height - 1 - (radius + 3))
	)

	monet.shape.circle(image, position, radius + 3, fill_colour * colour.New(0.1, 0.1, 0.1), true)
	monet.shape.circle(image, position, radius, fill_colour, true)
end

for i = 1, 100 do
	random_circle()
end

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
