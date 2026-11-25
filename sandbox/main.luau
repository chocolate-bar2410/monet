--!strict

const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local base = colour.FromHex("6495ED")

local image = monet.image.fromColour(128,128, base)

monet.shape.rect(image,vector.create(32, 32),vector.create(64,64),colour.New(1,1,1),true)
monet.shape.rect(image,vector.create(32, 32),vector.create(64,64),colour.New(0,0,0),false)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
