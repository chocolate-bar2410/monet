--!strict
const colour = require("@vara/colour")
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
    @method fromColour
    @param width
    @param height
    @param colour_0
    @param colour_1
    @param position_0
    @param position_1

    Creates a width x height image with a linear gradient.
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

	local lightness_0, chroma_0, hue_0 = colour_0:ToOKLCH()
	local lightness_1, chroma_1, hue_1 = colour_1:ToOKLCH()

	local delta = ((hue_1 - hue_0 + 540) % 360) - 180

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
            t = math.clamp(t,0,1)

			local hue = (hue_0 + t * delta + 360) % 360
			if math.isnan(hue) then
				hue = 0
			end

			local result = colour.FromOKLCH(
				math.lerp(lightness_0, lightness_1, t),
				math.lerp(chroma_0, chroma_1, t),
				hue,
				math.lerp(colour_0.Alpha, colour_1.Alpha, t)
			)

			return result
		end
	)
end

return module
