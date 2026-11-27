--!strict
const monet = require("@monet")
local colour = require("@vara/colour")
const fs = require("@vara/fs")


local points = monet.spatial.phyllotaxis(512,200,0.5)

for i,v in points do
	points[i] += vector.create(256,256)
end

local image = monet.image.fromLambda(
	512,
	512,
	monet.noise.voronoi(points,10)
)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
