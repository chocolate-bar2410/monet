--!strict
local interface = {}
local schema = {}
local meta = { __index = schema }

type node = { left: node?, right: node?, value: vector,axis: number }

local function createNode(left: node?, right: node?, value: vector,axis: number): node
	return {
		left = left,
		right = right,
		value = value,
        axis = axis
	}
end

local function build_tree(points: {vector},depth: number?): node?
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

function interface.new(points: {vector})
	local tree = {}
	tree.root = build_tree(points)

	return setmetatable(tree, meta)
end

function schema.closest(index: vector) end

return interface
