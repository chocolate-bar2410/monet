--!strict
const media = require("@vara/media")
const module = {}

const BIT_DEPTH = 4
const CC_CHANNELS = 4

function module.fromFillColour(width: number, height: number, fill_colour: Colour4)
	local image = media.Image(buffer.create(width * height * BIT_DEPTH * CC_CHANNELS))

	for y = 0, height - 1 do
		for x = 0, width - 1 do
			image:SetPixel(x, y, fill_colour)
		end
	end

    return image
end

return module
