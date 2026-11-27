--!strict
local types = require("../types")

local interface = {}
local schema = {}
local meta = { __index = schema }

local function createNode(left: types.KdNode?, right: types.KdNode?, value: vector,axis: number): types.KdNode
	return {
		left = left,
		right = right,
		value = value,
        axis = axis
	}
end

local function build_tree(points: {vector},depth: number?): types.KdNode?
    if #points == 0 then
        return nil
    end
    depth = depth or 0

    local axis = depth % 2

    table.sort(points,function(a: vector, b: vector): boolean  
        if axis == 0 then
            return a.x < b.x
        else
            return a.y < b.y
        end
    end)

    local median = (#points + 1) // 2
    
    local left = {}
    local right = {}

    for i = 1,median - 1 do
        left[#left + 1] = points[i]
    end

    for i = median + 1, #points do
        right[#right + 1] = points[i]
    end

    return createNode(
        build_tree(left,depth + 1),
        build_tree(right,depth + 1),
        points[median],
        axis
    )
end

local function search_closest(root: types.KdNode,value: vector)
    
    local difference = root.value - value
    local distance2 = vector.dot(difference, difference)

    local left
    local right

    
    if root.left == nil and root.right == nil then
        return root.value
    end

    local closest = root.value
    local closest_distance = distance2

    if root.left then
        left = search_closest(root.left, value)
        local left_dist2 = vector.dot(left - value,left - value)

        if left_dist2 < distance2 then
            closest = left
            closest_distance = left_dist2
        end

    end

    if root.right then
        right = search_closest(root.right, value)
        local right_dist2 = vector.dot(right - value,right - value)

        if right_dist2 < closest_distance then
            closest = right
            closest_distance = right_dist2
        end
    end

    return closest
end

function interface.new(points: {vector})
	local tree = {}
	tree.root = build_tree(points)

	return setmetatable(tree, meta)
end

function schema.closest(self: types.KdTree,index: vector) 
    return search_closest(self.root, index)
end

return interface
