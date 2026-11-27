--!strict
local colour = require("@vara/colour")
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

function module.voronoi(points: {vector},num_values: number,seed: number): (x: number, y: number) -> Colour4
    assert(num_values > 1, "there must be atleast 2 or more values to create voronoi noise")

    local values = {}
    for i = 1,num_values do
        values[i] = (i - 1) / (num_values - 1)
    end

    local greymap = {}
    
    for i,point in points do
        local index = (hash21(point.x, point.y, seed) * num_values) // 1 + 1
        greymap[point] = values[index]
    end
    
    return function(x: number,y: number)

        local closest = nil
        local closest_distance2 = math.huge

        local position = vector.create(x, y)

        for i,point in points do
            local difference = position - point
            local distance2 = vector.dot(difference,difference)
            
            if distance2 < closest_distance2 then
                closest = point
                closest_distance2 = distance2
            end
        end

        if closest == nil then
            return colour.New(1,1,1)
        end

        return colour.New(greymap[closest],greymap[closest],greymap[closest])
    end
end


return module