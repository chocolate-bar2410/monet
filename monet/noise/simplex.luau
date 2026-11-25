--!strict
local colour = require("@vara/colour")

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

local function hash(x: number,y: number,seed: number): number
    
    local n = bit32.bxor(
        bit32.band(x,0x7fffffff),
        bit32.lshift(bit32.band(y, 0x7ffff),16),
        seed
    )

    n = bit32.bxor(n,bit32.rshift(n,13))
    n = bit32.band(n * 1274126177,0x7fffffff)
    n = bit32.bxor(n,bit32.rshift(n,16))

    return n % 8 + 1
end


return function(x: number,y: number,seed: number?) : Colour4
    seed = seed or 0
    local position = vector.create(x, y)

    local s_x = math.floor(x + (x + y) * FLOOR_FACTOR)
    local s_y = math.floor(y + (x + y) * FLOOR_FACTOR)

    local t = (s_x + s_y) * G_FACTOR
    local x0 = position - vector.create(s_x- t,s_y - t)
    local coord = (x0.x > x0.y) and vector.create(1, 0) or vector.create(0, 1)

    local g_vector = vector.create(G_FACTOR,G_FACTOR)

    local x1 = x0 - coord + g_vector
    local x2 = x0 - vector.create(1,1) + 2 * g_vector

    local d0 = vector.dot(x0,x0)
    local d1 = vector.dot(x1,x1)
    local d2 = vector.dot(x2,x2)

    local w0 = math.max(0.5 - d0,0)
    local w1 = math.max(0.5 - d1,0)
    local w2 = math.max(0.5 - d2,0)

    w0 *= w0 * w0 * w0
    w1 *= w1 * w1 * w1
    w2 *= w2 * w2 * w2

    local grad0 = hash(s_x,s_y,seed)
    local grad1 = hash(s_x+ coord.x,s_y + coord.y,seed)
    local grad2 = hash(s_x+ 1,s_y + 1,seed)

    local n0 = w0 * vector.dot(GRAD_TABLE[grad0], x0)
    local n1 = w1 * vector.dot(GRAD_TABLE[grad1], x1)
    local n2 = w2 * vector.dot(GRAD_TABLE[grad2], x2)

    local result = SIMPLEX_SCALE * (n0 + n1 + n2)

    return colour.New(result, result, result)
end