--!strict
const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local image = monet.image.fromColour(
	512,
	512,
	colour.New(0.02,0.02,0.02)
)

local radius = 30

local points = monet.spatial.poisson(vector.create(512,512),radius,1)

for _,v in points do
    v = vector.floor(v)

    monet.shape.circle(image, v, radius // 2, colour.New(1,1,1),true)
end

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
