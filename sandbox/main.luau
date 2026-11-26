--!strict
const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local image = monet.image.fromRadialGradient(
	512,
	512,
	colour.FromOKLCH(0.6573, 0.1611, 250.5),
	colour.FromOKLCH(0.6573, 0.1611, 338.09),
    300
)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
