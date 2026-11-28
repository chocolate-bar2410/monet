--!strict
local types = require("../types")
local colour = require("@vara/colour")

return function(kd_tree: types.KdTree) : types.noise_fn
    return function(x: number, y: number) : Colour4
        
        local position = vector.create(x, y)
        local closest = kd_tree:closest(position)

        local distance = vector.magnitude(position - closest)

        return colour.New(1,1,1)
    end
end
