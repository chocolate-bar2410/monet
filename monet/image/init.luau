--!strict
const media = require("@vara/media")

--[=[
    @class ImageLib

    Submodule for creating images with monet.
]=]
const module = {}

const BIT_DEPTH = 4
const CC_CHANNELS = 4

--[=[
    @within ImageLib
    @method fromColour
    @param width
    @param height
    @param fill_colour
    @return Image

    Creates a width x height image with a set fill colour
]=]
function module.fromColour(width: number, height: number, fill_colour: Colour4)
	local image = media.Image(buffer.create(width * height * BIT_DEPTH * CC_CHANNELS)):Dimensions(width, height)

	for y = 0, height - 1 do
		for x = 0, width - 1 do
			image:SetPixel(x, y, fill_colour)
		end
	end

	return image
end

type lambda_fn = (x: number, y: number) -> Colour4


--[=[
    @within ImageLib
    @method fromLambda
    @param width
    @param height
    @param lambda
    @return Image

    Creates a width x height image thats filled in by sampling a function.
]=]
function module.fromLambda(width: number, height: number, lambda: lambda_fn)
	local image = media.Image(buffer.create(width * height * BIT_DEPTH * CC_CHANNELS)):Dimensions(width, height)

	for y = 0, height - 1 do
		for x = 0, width - 1 do
			image:SetPixel(x, y, lambda(x, y))
		end
	end

	return image
end

return module
