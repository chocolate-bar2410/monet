--!strict
const monet = require("@monet")
local colour = require("@vara/colour")
const fs = require("@vara/fs")

local seed = 10

local tree = monet.spatial.kdTree.new(monet.spatial.phyllotaxis(50, 256))

print(tree)

-- fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
