--!strict
const types = require("../types")

local interface = {}
local schema = {}
local meta = { __index = schema }

local function createNode(left: types.KdNode?, right: types.KdNode?, value: vector, axis: number): types.KdNode
	return {
		left = left,
		right = right,
		value = value,
		axis = axis,
	}
end

local function build_tree(points: { vector }, depth: number?): types.KdNode?
	if #points == 0 then
		return nil
	end
	depth = depth or 0

	local axis = depth % 2

	table.sort(
		points,
		function(a: vector, b: vector): boolean
			if axis == 0 then
				return a.x < b.x
			else
				return a.y < b.y
			end
		end
	)

	local median = (#points + 1) // 2

	local left = {}
	local right = {}

	for i = 1, median - 1 do
		left[#left + 1] = points[i]
	end

	for i = median + 1, #points do
		right[#right + 1] = points[i]
	end

	return createNode(build_tree(left, depth + 1), build_tree(right, depth + 1), points[median], axis)
end

local function search_closest(root: types.KdNode?, value: vector, best: vector?, best_distance: number): (vector?, number)
	if root == nil then
		return best, best_distance
	end

	local difference = root.value - value
	local distance2 = vector.dot(difference, difference)

	if distance2 < best_distance then
		best = root.value
		best_distance = distance2
	end

	local axis_difference

	if root.axis == 0 then
		axis_difference = value.x - root.value.x
	else
		axis_difference = value.y - root.value.y
	end

	local near
	local far

	if axis_difference < 0 then
		near = root.left
		far = root.right
	else
		near = root.right
		far = root.left
	end

	best, best_distance = search_closest(near, value, best, best_distance)

	if axis_difference * axis_difference < best_distance then
		best, best_distance = search_closest(far, value, best, best_distance)
	end

	return best, best_distance
end

function interface.new(points: { vector })
	local tree = {}
	tree.root = build_tree(points) :: types.KdNode

	return setmetatable(tree, meta)
end

function schema.closest(self: types.KdTree, index: vector): vector
	local closest = search_closest(self.root, index, nil, math.huge)
	return closest :: vector
end

function schema.addPoint(self: types.KdTree, value: vector)
	if self.root == nil then
		self.root = createNode(nil, nil, value, 0)
		return
	end

	local current = self.root

	while true do
		local axis = current.axis
		local axis_difference = if current.axis == 0 then value.x - current.value.x else value.y - current.value.y

		if axis_difference > 0 then
			if current.left == nil then
				current.left = createNode(nil, nil, value, (axis + 1) % 2)
				break
			else
				current = current.left
			end
		else
			if current.right == nil then
				current.right = createNode(nil, nil, value, (axis + 1) % 2)
				break
			else
				current = current.right
			end
		end
	end
end

function schema.removePoint(self: types.KdTree, value: vector) 
    
end

return interface
