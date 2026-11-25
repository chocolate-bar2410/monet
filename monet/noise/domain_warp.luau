--!strict
type noise_fn = (x: number, y: number) -> Colour4

return function(noise_lambda: noise_fn, warp_lambda: noise_fn, warp_strength: number)
	return function(x: number, y: number)
		local warp_x = warp_lambda(x, y).Red
		local warp_y = warp_lambda(x + 100, y + 100).Red

		return noise_lambda(x + warp_x * warp_strength, y + warp_y * warp_strength)
	end
end
