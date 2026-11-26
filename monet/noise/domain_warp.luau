--!strict
type noise_fn = (x: number, y: number) -> Colour4

--[=[
    @within NoiseLib
	@method billow
	@param noise_lambda The base noise function being applied.
	@param warp_lambda The noise function used to offset the base noise.
	@param warp_strength How much the warp noise offsets the base noise.
	@return noise function

	Create a function that applys domain warping onto a noise function with another noise function.
]=]
return function(noise_lambda: noise_fn, warp_lambda: noise_fn, warp_strength: number)
	return function(x: number, y: number)
		local warp_x = warp_lambda(x, y).Red
		local warp_y = warp_lambda(x + 100, y + 100).Red

		return noise_lambda(x + warp_x * warp_strength, y + warp_y * warp_strength)
	end
end
