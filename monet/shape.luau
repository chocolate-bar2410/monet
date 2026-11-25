--!strict

--[=[
    @class ShapeLib

    Submodule for drawing shapes on images with monet.
]=]
const module = {}

--[=[
    @within ShapeLib
    @method circle
    @param image The image to draw to.
    @param center The centerpoint of the circle.
    @param radius The radius of the circle.
    @param base_colour The colour of the circle.
    @param fill Whether to fill in the circle.

    Draws a circle onto an image that can be optionally filled in.
]=]
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

--[=[
    @within ShapeLib
    @method rect
    @param image The image to draw to.
    @param position The position of the top left corner.
    @param size The size of the rectangle.
    @param base_colour The colour of the rectangle.
    @param fill Whether to fill in the rectangle.

    Draws a rectangle onto an image that can be optionally filled in.
]=]
function module.rect(image: Image, position: vector,size: vector, base_colour: Colour4, fill: boolean?)
	fill = if fill ~= nil then fill else false

	local x_goal = position.x + size.x
	local y_goal = position.y + size.y

	if fill then
		for y = position.y, y_goal do
			for x = position.x, x_goal do
				image:SetPixel(x, y, base_colour)
			end
		end
	else
		for x = position.x, x_goal do
			image:SetPixel(x, position.y, base_colour)
			image:SetPixel(x, y_goal, base_colour)
		end
		
		for y = position.y, y_goal do
			image:SetPixel(position.x, y, base_colour)
			image:SetPixel(x_goal, y, base_colour)
		end

	end
end

return module
