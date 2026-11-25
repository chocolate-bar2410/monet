--!strict

const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local base = colour.FromHex("6495ED")

local image = monet.image.fromColour(256, 256, base)

monet.shape.circle(image, vector.create(128, 128), 64, colour.New(1, 1, 1),true)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
