--!strict
local types = require("../types")
local colour = require("@vara/colour")

return function(kd_tree: types.KdTree,max_radius: number,exponent: number?) : types.noise_fn
    exponent = exponent or 1

    return function(x: number, y: number) : Colour4
        
        local position = vector.create(x, y)
        local closest = kd_tree:closest(position)

        local distance = vector.magnitude(position - closest)

        local value = math.clamp((distance / max_radius) ^ exponent :: number,0,1)
        value = value * value * (3 - 2 * value)

        return colour.New(value,value,value)
    end
end
