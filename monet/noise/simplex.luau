--!strict
const colour = require("@vara/colour")

const FLOOR_FACTOR = (math.sqrt(3) - 1) / 2
const G_FACTOR = (3 - math.sqrt(3)) / 6

const SIMPLEX_SCALE = 40

const GRAD_TABLE = {
	vector.create(1, 1),
	vector.create(-1, 1),
	vector.create(1, -1),
	vector.create(-1, -1),

	vector.create(1, 0),
	vector.create(-1, 0),
	vector.create(0, 1),
	vector.create(0, -1),
}

-- from original research paper https://cgvr.cs.uni-bremen.de/teaching/cg_literatur/simplexnoise.pdf
--larvae: fmt off
const PERM_TABLE = {
    151, 160, 137,  91,  90,  15, 131,  13, 201,  95,  96,  53, 194, 233,   7, 225,
    140,  36, 103,  30,  69, 142,   8,  99,  37, 240,  21,  10,  23, 190,   6, 148,
    247, 120, 234,  75,   0,  26, 197,  62,  94, 252, 219, 203, 117,  35,  11,  32,
     57, 177,  33,  88, 237, 149,  56,  87, 174,  20, 125, 136, 171, 168,  68, 175,
     74, 165,  71, 134, 139,  48,  27, 166,  77, 146, 158, 231,  83, 111, 229, 122,
     60, 211, 133, 230, 220, 105,  92,  41,  55,  46, 245,  40, 244, 102, 143,  54,
     65,  25,  63, 161,   1, 216,  80,  73, 209,  76, 132, 187, 208,  89,  18, 169,
    200, 196, 135, 130, 116, 188, 159,  86, 164, 100, 109, 198, 173, 186,   3,  64,
     52, 217, 226, 250, 124, 123,   5, 202,  38, 147, 118, 126, 255,  82,  85, 212,
    207, 206,  59, 227,  47,  16,  58,  17, 182, 189,  28,  42, 223, 183, 170, 213,
    119, 248, 152,   2,  44, 154, 163,  70, 221, 153, 101, 155, 167,  43, 172,   9,
    129,  22,  39, 253,  19,  98, 108, 110,  79, 113, 224, 232, 178, 185, 112, 104,
    218, 246,  97, 228, 251,  34, 242, 193, 238, 210, 144,  12, 191, 179, 162, 241,
     81,  51, 145, 235, 249,  14, 239, 107,  49, 192, 214,  31, 181, 199, 106, 157,
    184,  84, 204, 176, 115, 121,  50,  45, 127,   4, 150, 254, 138, 236, 205,  93,
    222, 114,  67,  29,  24,  72, 243, 141, 128, 195,  78,  66, 215,  61, 156, 180
};
--larvae: fmt on

local function hash(x: number, y: number, seed: number): number
	local i = bit32.band(x + seed, 0xFF)
	local j = bit32.band(y, 0xFF)

	return PERM_TABLE[bit32.band(i + PERM_TABLE[j + 1], 0xFF) + 1] % 8 + 1
end

--[=[
    @within NoiseLib
	@method simplex
	@param x
	@param y
	@param seed
	@return colour

	Samples a simplex noise value.
]=]
return function(x: number, y: number, seed: number?): Colour4
	seed = seed or 0
	local position = vector.create(x, y)

	local s_x = math.floor(x + (x + y) * FLOOR_FACTOR)
	local s_y = math.floor(y + (x + y) * FLOOR_FACTOR)

	local t = (s_x + s_y) * G_FACTOR
	local x0 = position - vector.create(s_x - t, s_y - t)
	local coord = (x0.x > x0.y) and vector.create(1, 0) or vector.create(0, 1)

	local g_vector = vector.create(G_FACTOR, G_FACTOR)

	local x1 = x0 - coord + g_vector
	local x2 = x0 - vector.create(1, 1) + 2 * g_vector

	local d0 = vector.dot(x0, x0)
	local d1 = vector.dot(x1, x1)
	local d2 = vector.dot(x2, x2)

	local w0 = math.max(0.5 - d0, 0)
	local w1 = math.max(0.5 - d1, 0)
	local w2 = math.max(0.5 - d2, 0)

	w0 *= w0 * w0 * w0
	w1 *= w1 * w1 * w1
	w2 *= w2 * w2 * w2

	local grad0 = hash(s_x, s_y, seed)
	local grad1 = hash(s_x + coord.x, s_y + coord.y, seed)
	local grad2 = hash(s_x + 1, s_y + 1, seed)

	local n0 = w0 * vector.dot(GRAD_TABLE[grad0], x0)
	local n1 = w1 * vector.dot(GRAD_TABLE[grad1], x1)
	local n2 = w2 * vector.dot(GRAD_TABLE[grad2], x2)

	local result = SIMPLEX_SCALE * (n0 + n1 + n2)

	return colour.New(result, result, result)
end
