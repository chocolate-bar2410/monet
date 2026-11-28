--!strict
const monet = require("@monet")
local colour = require("@vara/colour")
const fs = require("@vara/fs")

local seed = 10

local points = monet.spatial.poisson(vector.create(512, 512),100,seed)

local tree = monet.spatial.kdTree.new(points)


local image = monet.image.fromLambda(512,512, monet.noise.worley(tree,256,1.2))

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
