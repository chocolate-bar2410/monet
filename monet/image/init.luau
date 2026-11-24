--!strict
const media = require("@vara/media")
const module = {}

const BIT_DEPTH = 4
const CC_CHANNELS = 4

function module.fromColour(width: number, height: number, fill_colour: Colour4)
	local image = media.Image(buffer.create(width * height * BIT_DEPTH * CC_CHANNELS)):Dimensions(width, height)

	for y = 0, height - 1 do
		for x = 0, width - 1 do
			image:SetPixel(x, y, fill_colour)
		end
	end

    return image
end

type lambda_fn = (x: number,y: number) -> Colour4

function module.fromLambda(width: number, height: number, lambda: lambda_fn)
	local image = media.Image(buffer.create(width * height * BIT_DEPTH * CC_CHANNELS)):Dimensions(width, height)

	for y = 0, height - 1 do
		for x = 0, width - 1 do
			image:SetPixel(x, y, lambda(x,y))
		end
	end

    return image
end

return module
