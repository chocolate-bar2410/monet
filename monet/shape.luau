--!strict
const media = require("@vara/media")

--[=[
    @class ShapeLib

    Submodule for drawing shapes on images with monet.
]=]
const module = {}

function module.circle(image: Image, center: vector, radius: number, base_colour: Colour4, fill: boolean?)
	fill = if fill ~= nil then fill else false

	local x = 0
	local y = -radius

	local p = -radius + 1.25

	while x < -y do
		if p > 0 then
			y += 1
			p += 2 * (x + y) + 1
		else
			p += 2 * x + 1
		end

		if fill then
			for i = center.x + y, center.x - y do
				image:SetPixel(i, center.y + x, base_colour)
				image:SetPixel(i, center.y - x, base_colour)
			end

			for i = center.x - x, center.x + x do
				image:SetPixel(i, center.y - y, base_colour)
				image:SetPixel(i, center.y + y, base_colour)
			end
		else
			image:SetPixel(center.x + x, center.y + y, base_colour)
			image:SetPixel(center.x - x, center.y + y, base_colour)
			image:SetPixel(center.x + x, center.y - y, base_colour)
			image:SetPixel(center.x - x, center.y - y, base_colour)
			image:SetPixel(center.x + y, center.y + x, base_colour)
			image:SetPixel(center.x - y, center.y + x, base_colour)
			image:SetPixel(center.x + y, center.y - x, base_colour)
			image:SetPixel(center.x - y, center.y - x, base_colour)
		end

		x += 1
	end
end

return module
