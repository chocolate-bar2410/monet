--!strict
-- borrowed these methods from numluau (https://github.com/chocolate-bar2410/numluau)

const module = {}
const BIT32_MAX = 2 ^ 32
const GOLD = 0x9E3779B9

local multiply32 = function(x1: number, x2: number): (number, number)
	local x1_low = bit32.band(x1, 0xFFFF)
	local x2_low = bit32.band(x2, 0xFFFF)

	local x1_high = bit32.rshift(x1, 16)
	local x2_high = bit32.rshift(x2, 16)

	local p00 = x1_low * x2_low
	local p01 = x1_low * x2_high
	local p10 = x1_high * x2_low
	local p11 = x1_high * x2_high

	local mid = p01 + p10
	local mid_low = bit32.band(mid, 0xFFFF)
	local mid_high = bit32.rshift(mid, 16)

	local low = bit32.band(p00 + bit32.lshift(mid_low, 16), 0xFFFFFFFF)

	local carry = bit32.rshift(p00 + bit32.lshift(mid_low, 16), 32)

	local high = bit32.band(p11 + mid_high + carry, 0xFFFFFFFF)

	return high, low
end

module.lemire_constrain = function(bit_generator: () -> number, min: number, max: number)
	local range = max - min + 1

	local value = bit_generator()
	local multiplied, fractional = multiply32(value, range)

	if fractional < range then
		local threshold = (BIT32_MAX - range) % range

		while fractional < threshold do
			value = bit_generator()
			multiplied, fractional = multiply32(value, range)
		end
	end

	return min + multiplied
end

local splitmix32 = function(seed: number)
	local result = seed + GOLD
	result = bit32.bxor(result, bit32.rshift(result, 16)) * 0x85EBCA6B
	result = bit32.bxor(result, bit32.rshift(result, 13)) * 0xC2B2AE35

	return bit32.bxor(result, bit32.rshift(result, 16))
end

module.XOSHIRO128 = function(seed: number): () -> number
	seed = seed or math.round(os.clock())
	local s1 = seed
	local s2 = splitmix32(seed)
	local s3 = splitmix32(seed + GOLD)
	local s4 = splitmix32(seed + (GOLD * 2))

	return function()
		local result = bit32.band((bit32.lrotate((s2 * 5), 7) * 9), 0xFFFFFFFF)

		local temp = bit32.lshift(s2, 9)

		s3 = bit32.bxor(s3, s1)
		s4 = bit32.bxor(s4, s2)
		s2 = bit32.bxor(s2, s3)
		s1 = bit32.bxor(s1, s4)

		s3 = bit32.bxor(s3, temp)
		s4 = bit32.lrotate(s4, 11)

		return result
	end
end

return module