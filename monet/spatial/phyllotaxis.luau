--!strict

--[=[
    @within SpatialLib
    @method phyllotaxis
    @param point_count The number of points sampled.
    @param radius The radius of the phyllotaxis.
    @param exponent The radial distribution of points, defaults to 1.
    @param turn_fraction Controls the angular rotation between each point, defaults to the reciprocal of the golden ratio.
    @return Sampled points.
    Creates a set of points sampled using a 2d fibonacci lattice.
]=]
return function(point_count: number,radius: number,exponent: number?,turn_fraction: number?)
    exponent = exponent or 1
    
    turn_fraction = turn_fraction or 1 / math.phi

    local result: {vector} = {}

    for i = 1,point_count do
        local distance = math.min((i / (point_count - 1)) ^ exponent * radius,radius)
        local angle = 2 * math.pi * turn_fraction * i

        result[#result + 1] = vector.create(
            distance * math.cos(angle),
            distance * math.sin(angle)
        )
    end

    return result
end
