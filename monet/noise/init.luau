--!strict
const fbm = require("@self/fbm")

--[=[
    @class NoiseLib

    Submodule for creating composable noise functions using monet.
]=]
return {
	fractalBrownian = fbm.fractalBrownian,
	billow = fbm.billow,
	domainWarp = require("@self/domain_warp"),
	simplex = require("@self/simplex"),
	worley = require("@self/worley")
}
