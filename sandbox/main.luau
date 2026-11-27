--!strict
const monet = require("@monet")
local kd_tree = require("@monet/utility/kd_tree")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local points = monet.spatial.poisson(vector.create(512,512), 40)

local image = monet.image.fromLambda(
	512,
	512,
	monet.noise.voronoi(points,10,12)
)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
