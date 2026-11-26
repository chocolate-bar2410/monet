--!strict
const colour = require("@vara/colour")

--[=[
    @class ShapeLib

    Submodule for drawing shapes on images with monet.
]=]
const module = {}

local function draw_composite(image: Image, x: number, y: number, coverage: number, base_colour: Colour4)
	if x >= image.Width or y >= image.Height then
		return
	end

	local previous_top = image:GetPixel(x, y)

	local source_alpha = base_colour.Alpha * coverage
	local dest_alpha = previous_top.Alpha

	local out_alpha = math.lerp(source_alpha, 1, dest_alpha)

	local result = base_colour * colour.New(source_alpha, source_alpha, source_alpha)
		+ previous_top
			* colour.New(
				dest_alpha * (1 - source_alpha),
				dest_alpha * (1 - source_alpha),
				dest_alpha * (1 - source_alpha)
			)

	if out_alpha > 0 then
		result /= colour.New(out_alpha, out_alpha, out_alpha)
	end

	image:SetPixel(x, y, result)
end

--[=[
    @within ShapeLib
    @method circle
    @param image The image to draw to.
    @param center The centerpoint of the circle.
    @param radius The radius of the circle.
    @param base_colour The colour of the circle.
    @param fill Whether to fill in the circle.

    Draws a circle on the image that can be optionally filled in.
]=]
function module.circle(image: Image, center: vector, radius: number, base_colour: Colour4, fill: boolean?)
	fill = if fill ~= nil then fill else false

	local x = 0
	local y = -radius

	while x < -y do
		if x ^ 2 + (y + 0.5) ^ 2 > radius * radius then
			y += 1
		end

		local y_mid = y + 0.5

		local distance = math.sqrt(x ^ 2 + y_mid ^ 2)
		local intensity = math.clamp(radius - distance + 0.5, 0, 1)

		if fill then
			for i = center.x + y, center.x - y do
				draw_composite(image, i, center.y + x, 1, base_colour)
				draw_composite(image, i, center.y - x, 1, base_colour)
			end

			for i = center.x - x, center.x + x do
				draw_composite(image, i, center.y - y, 1, base_colour)
				draw_composite(image, i, center.y + y, 1, base_colour)
			end
		else
			draw_composite(image, center.x + x, center.y + y, intensity, base_colour)
			draw_composite(image, center.x - x, center.y + y, intensity, base_colour)
			draw_composite(image, center.x + x, center.y - y, intensity, base_colour)
			draw_composite(image, center.x - x, center.y - y, intensity, base_colour)

			draw_composite(image, center.x + y, center.y + x, intensity, base_colour)
			draw_composite(image, center.x - y, center.y + x, intensity, base_colour)
			draw_composite(image, center.x + y, center.y - x, intensity, base_colour)
			draw_composite(image, center.x - y, center.y - x, intensity, base_colour)

			local inner_dist = vector.magnitude(vector.create(x, y + 1))
			local inner_intensity = math.clamp(1 - math.abs(inner_dist - radius), 0, 1)

			draw_composite(image, center.x + x, center.y + y + 1, inner_intensity, base_colour)
			draw_composite(image, center.x - x, center.y + y + 1, inner_intensity, base_colour)
			draw_composite(image, center.x + x, center.y - y - 1, inner_intensity, base_colour)
			draw_composite(image, center.x - x, center.y - y - 1, inner_intensity, base_colour)

			draw_composite(image, center.x - y - 1, center.y + x, inner_intensity, base_colour)
			draw_composite(image, center.x + y + 1, center.y + x, inner_intensity, base_colour)
			draw_composite(image, center.x - y - 1, center.y - x, inner_intensity, base_colour)
			draw_composite(image, center.x + y + 1, center.y - x, inner_intensity, base_colour)
		end

		local outer_dist = vector.magnitude(vector.create(x, y - 1))
		local outer_intensity = math.clamp(1 - math.abs(outer_dist - radius), 0, 1)

		draw_composite(image, center.x + x, center.y + y - 1, outer_intensity, base_colour)
		draw_composite(image, center.x - x, center.y + y - 1, outer_intensity, base_colour)
		draw_composite(image, center.x + x, center.y - y + 1, outer_intensity, base_colour)
		draw_composite(image, center.x - x, center.y - y + 1, outer_intensity, base_colour)

		draw_composite(image, center.x - y + 1, center.y + x, outer_intensity, base_colour)
		draw_composite(image, center.x + y - 1, center.y + x, outer_intensity, base_colour)
		draw_composite(image, center.x - y + 1, center.y - x, outer_intensity, base_colour)
		draw_composite(image, center.x + y - 1, center.y - x, outer_intensity, base_colour)
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

    Draws a rectangle on the image that can be optionally filled in.
]=]
function module.rect(image: Image, position: vector, size: vector, base_colour: Colour4, fill: boolean?)
	fill = if fill ~= nil then fill else false

	local x_goal = position.x + size.x
	local y_goal = position.y + size.y

	if fill then
		for y = position.y, y_goal do
			for x = position.x, x_goal do
				draw_composite(image, x, y, 1, base_colour)
			end
		end
	else
		for x = position.x, x_goal do
			draw_composite(image, x, position.y, 1, base_colour)
			draw_composite(image, x, y_goal, 1, base_colour)
		end

		for y = position.y, y_goal do
			draw_composite(image, position.x, y, 1, base_colour)
			draw_composite(image, x_goal, y, 1, base_colour)
		end
	end
end

--[=[
    @within ShapeLib
    @method line
    @param image The image to draw to.
    @param position The start position of the line.
    @param goal The end position of the line.
    @param line_colour The colour of the line.

    Draws a line on the image.
]=]
function module.line(image: Image, position: vector, goal: vector, line_colour: Colour4)
	if math.abs(goal.y - position.y) < math.abs(goal.x - position.x) then
		if goal.x < position.x then
			position, goal = goal, position
		end

		local diff = goal - position
		local gradient = if diff.x ~= 0 then diff.y / diff.x else 1

		for i = 0, math.floor(diff.x) do
			local x = position.x + i
			local y = position.y + i * gradient

			local ix, iy = math.floor(x), math.floor(y)

			local dist = y - iy

			draw_composite(image, ix, iy, 1 - dist, line_colour)
			draw_composite(image, ix, iy + 1, dist, line_colour)
		end
	else
		if goal.y < position.y then
			position, goal = goal, position
		end

		local diff = goal - position
		local gradient = if diff.y ~= 0 then diff.x / diff.y else 1

		for i = 0, math.floor(diff.y) do
			local x = position.x + i * gradient
			local y = position.y + i

			local ix, iy = math.floor(x), math.floor(y)

			local dist = x - ix

			draw_composite(image, ix, iy, 1 - dist, line_colour)
			draw_composite(image, ix + 1, iy, dist, line_colour)
		end
	end
end

function module.polyline(image: Image, positions: { vector }, line_colour: Colour4)
	if #positions == 0 then
		return
	end

	for i = 1, #positions - 1 do
		module.line(image, positions[i], positions[i + 1], line_colour)
	end
end

return module
