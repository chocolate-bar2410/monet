--!strict
const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local points = {
	vector.create(128,128),
	vector.create(348,348),
}


local image = monet.image.fromLambda(
	512,
	512,
	monet.noise.voronoi(points,4)
)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
