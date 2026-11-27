--!strict
const random_util = require("../utility/random")

const MAX_ATTEMPTS = 30
const RNG_MAX = 2 ^ 32

local function is_valid(candidate: vector, bounds: vector, radius: number, points: { vector }, grid: { { number } }): boolean
	if candidate.x >= bounds.x or candidate.y >= bounds.y or candidate.x < 0 or candidate.y < 0 then
		return false
	end

	const CELL_SIZE = radius / math.sqrt2
	const GRID_WIDTH = math.ceil(bounds.x / CELL_SIZE)
	const GRID_HEIGHT = math.ceil(bounds.y / CELL_SIZE)

	local cell = vector.floor(candidate / CELL_SIZE)

	local start_x = math.max(cell.x - 2, 1)
	local goal_x = math.min(cell.x + 2, GRID_WIDTH)

	local start_y = math.max(cell.y - 2, 1)
	local goal_y = math.min(cell.y + 2, GRID_HEIGHT)

	for y = start_y, goal_y do
		for x = start_x, goal_x do
			local point_index = grid[y][x]

			if point_index == 0 then
				continue
			end

			local distance = vector.magnitude(candidate - points[point_index])

			if distance >= radius then
				continue
			end

			return false
		end
	end

	return true
end

--[=[
	@within SpatialLib
	@method poisson
	@param bounds The size of the sampler's bounding box.
	@param radius The minimum distance a point can be to another point.
	@return Points.

	Creates a set of points that are spaced out at a minimum distance using poisson disk sampling.
]=]
return function(bounds: vector, radius: number, seed: number?): { vector }
	local rng = random_util.XOSHIRO128(seed or 0)
	local grid: { { number } } = {}

	const CELL_SIZE = radius / math.sqrt2
	const GRID_WIDTH = math.ceil(bounds.x / CELL_SIZE)
	const GRID_HEIGHT = math.ceil(bounds.y / CELL_SIZE)

	for y = 1, GRID_HEIGHT do
		grid[y] = {}
		for x = 1, GRID_WIDTH do
			grid[y][x] = 0
		end
	end

	local active: { vector } = {}
	local points: { vector } = {}

	table.insert(active, bounds // 2)

	while #active > 0 do
		local spawn_index = random_util.lemire_constrain(rng, 1, #active)
		local spawn_center = active[spawn_index]

		local accepted = false

		for i = 1, MAX_ATTEMPTS do
			local angle = rng() / RNG_MAX * math.tau
			local direction = vector.create(math.sin(angle), math.cos(angle))
			local candidate = spawn_center + direction * random_util.lemire_constrain(rng, radius, 2 * radius)

			if is_valid(candidate, bounds, radius, points, grid) then
				active[#active + 1] = candidate
				points[#points + 1] = candidate

				grid[candidate.y // CELL_SIZE + 1][candidate.x // CELL_SIZE + 1] = #points
				accepted = true
				break
			end
		end

		if accepted == false then
			table.remove(active, spawn_index)
		end
	end

	return points
end
