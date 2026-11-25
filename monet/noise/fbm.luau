--!strict
local colour = require("@vara/colour")

type noise_fn = (x: number,y: number) -> Colour4

local module = {}

module.fractalBrownian = function(noise_lambda: noise_fn,octaves: number,lacunarity: number,persistence: number) : noise_fn

    return function(x: number,y: number)
        local frequency = 1
        local amplitude = 0.5

        local total_amplitude = 0

        local result = colour.New(0,0,0)

        for octave = 1, octaves do
            result += colour.New(amplitude,amplitude,amplitude) * noise_lambda(x * frequency,y * frequency)
            total_amplitude += amplitude

            frequency *= lacunarity
            amplitude *= persistence
        end

        return result / colour.New(total_amplitude,total_amplitude,total_amplitude)
    end
	
end

return module