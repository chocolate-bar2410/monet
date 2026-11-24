--!strict

const monet = require("@monet")
const colour = require("@vara/colour")
const fs = require("@vara/fs")

local base = colour.FromHex("6495ED")

local image = monet.image.fromColour(512,512, base)

monet.shape.circle(image,vector.create(256,256),135,colour.New(0,0,0),true)
monet.shape.circle(image,vector.create(256,256),128,colour.New(1,1,1),true)

fs.File("sandbox/test.png"):Write(image:Encode("PNG"))
