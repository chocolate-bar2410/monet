--!strict

const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local base = colour.FromHex("6495ED")

local image = monet.image.fromColour(128, 128, base)

monet.shape.line(image, vector.create(32, 32), vector.create(96, 64), colour.New(1, 1, 1))

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
