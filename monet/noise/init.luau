--!strict
const fbm = require("@self/fbm")
const voronoi = require("@self/voronoi")

--[=[
    @class NoiseLib

    Submodule for creating composable noise functions using monet.
]=]
return {
	fractalBrownian = fbm.fractalBrownian,
	billow = fbm.billow,
	domainWarp = require("@self/domain_warp"),
	simplex = require("@self/simplex"),
	voronoi = voronoi.voronoi
}
