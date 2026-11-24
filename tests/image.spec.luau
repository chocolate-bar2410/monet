const monet = require("@monet")
const colour = require("@vara/colour")
const unit = require("@vara/test/unit")
const module = {}

module["Create from Fill Colour"] = function()
	local a = monet.image.fromColour(16, 16, colour.New(1, 0, 1))

	for y = 0, a.Height - 1 do
		for x = 0, a.Width - 1 do
			unit.AssertEquals(a:GetPixel(x, y), colour.New(1, 0, 1))
		end
	end

    unit.AssertThrows(monet.image.fromColour,16, 16, nil)
    unit.AssertThrows(monet.image.fromColour,nil,nil,nil)
end

module["Create from lambda Colour"] = function()
    local sample = {
        colour.New(0,0,0),
        colour.New(1,0,0),
        colour.New(0,1,0),
        colour.New(0,0,1),
    }
    
    local lambda = function(x,y)
        return sample[y * 2 + x + 1]
    end

	local a = monet.image.fromLambda(2, 2, lambda)

	for y = 0, a.Height - 1 do
		for x = 0, a.Width - 1 do
			unit.AssertEquals(a:GetPixel(x, y), lambda(x,y))
		end
	end

    unit.AssertThrows(monet.image.fromLambda,2, 2, nil)
    unit.AssertThrows(monet.image.fromLambda,nil,nil,nil)
end


return module
