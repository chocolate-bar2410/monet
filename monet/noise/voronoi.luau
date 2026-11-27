--!strict
local colour = require("@vara/colour")
const module = {}

function module.voronoi(points: {vector},num_values: number): (x: number, y: number) -> Colour4
    assert(num_values > 1, "there must be atleast 2 or more values to create voronoi noise")

    local values = {}
    for i = 1,num_values do
        values[i] = (num_values - 1) / i
    end

    local greymap = {}
    
    for i,point in points do
        local index = (i % num_values) + 1
        greymap[point] = values[index]
    end
    
    return function(x: number,y: number)

        local closest = nil
        local closest_distance = math.huge

        local position = vector.create(x, y)

        for i,point in points do
           if vector.magnitude(position - point) < closest_distance then
                closest = point
            end
        end

        if closest == nil then
            return colour.New(1,1,1)
        end

        return colour.New(greymap[closest],greymap[closest],greymap[closest])
    end
end


return module