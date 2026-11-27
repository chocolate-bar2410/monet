--!strict
local colour = require("@vara/colour")
local kd_tree = require("../utility/kd_tree")

const module = {}

local function hash21(x: number, y: number, seed: number)
    local p3x = (x * 0.1031 + seed * 0.103) % 1
    local p3y = (y * 0.1031 + seed * 0.103) % 1
    local p3z = (x * 0.1031 + seed * 0.103) % 1

    local dot = p3x * (p3y * 33.33) + p3y * (p3z * 33.33) + p3z * (p3x * 33.33)

    p3x += dot
    p3y += dot
    p3z += dot

    return ((p3x + p3y) * p3z) % 1
end

function module.voronoi(points: {vector},num_values: number,seed: number?): (x: number, y: number) -> Colour4
    assert(num_values > 1, "there must be atleast 2 or more values to create voronoi noise")

    seed = seed or 0

    local values = {}
    for i = 1,num_values do
        values[i] = (i - 1) / (num_values - 1)
    end

    local greymap = {}
    
    for i,point in points do
        local index = (hash21(point.x, point.y, seed) * num_values) // 1 + 1
        greymap[point] = values[index]
    end

    local point_tree = kd_tree.new(points)
    
    return function(x: number,y: number)

        local closest = point_tree:closest(vector.create(x, y))
        
        if closest == nil then
            return colour.New(1,1,1)
        end

        return colour.New(greymap[closest],greymap[closest],greymap[closest])
    end
end


return module