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

--[=[
    @within ImageLib
    @method fromGradient
    @param width
    @param height
    @param colour_0
    @param colour_1
    @param position_0
    @param position_1

    Creates a width x height image using a linear gradient.
]=]
function module.fromGradient(
	width: number,
	height: number,
	colour_0: Colour4,
	colour_1: Colour4,
	position_0: vector?,
	position_1: vector?
)
	position_0 = position_0 or vector.create(width // 2, 0)
	position_1 = position_1 or vector.create(width // 2, height - 1)

	local difference = position_1 - position_0
	local distance = vector.magnitude(difference)

	return module.fromLambda(
		width,
		height,
		function(x: number, y: number): Colour4
			local vx = x - (position_0 :: vector).x
			local vy = y - (position_0 :: vector).y

			local t = 0

			if distance < 1e-6 then
				return colour_0
			end

			t = (vx * difference.x + vy * difference.y) / (distance ^ 2)
			t = math.clamp(t, 0, 1)

			local result = colour_0:Clone():OKLCHMix(colour_1, t)

			return result
		end
	)
end

--[=[
    @within ImageLib
    @method fromGradient
    @param width
    @param height
    @param colour_0
    @param colour_1
    @param radial

    Creates a width x height image using a radial gradient.
]=]
function module.fromRadialGradient(width: number, height: number, colour_0: Colour4, colour_1: Colour4, radius: number)
	return module.fromLambda(
		width,
		height,
		function(x: number, y: number): Colour4
			local distance = math.sqrt((x - width // 2) ^ 2 + (y - height // 2) ^ 2)

			local t = math.clamp(distance / radius, 0, 1)

			if distance < 1e-6 then
				return colour_0
			end

			local result = colour_0:Clone():OKLCHMix(colour_1, t)

			return result
		end
	)
end

return module
