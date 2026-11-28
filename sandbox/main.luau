--!strict
const monet = require("@monet")
local kd_tree = require("@monet/utility/kd_tree")
local colour = require("@vara/colour")
const fs = require("@vara/fs")

local seed = 10
local points = {}

local tree = kd_tree.new(points)

tree:addPoint(vector.create(4,4))
tree:addPoint(vector.create(5,2))
tree:addPoint(vector.create(5,2))
tree:addPoint(vector.create(4,0))

print(tree)

-- fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
