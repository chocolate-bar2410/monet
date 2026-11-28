--!strict

--[=[
    @class SpatialLib

    Submodule for sampling distributions and spatial partitions.
]=]
return {
	poisson = require("@self/poisson"),
    phyllotaxis = require("@self/phyllotaxis"),
    kdTree = require("@self/kd_tree")
}
