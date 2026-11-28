--!strict
const monet = require("@monet")
local kd_tree = require("@monet/utility/kd_tree")
local colour = require("@vara/colour")
const fs = require("@vara/fs")

local seed = 10
local points = monet.spatial.phyllotaxis(50, 256)

local tree = kd_tree.new({})

for i,v in points do
	tree:addPoint(v)
end


print(tree)

-- fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
