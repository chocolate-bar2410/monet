--!strict
local fbm = require("@self/fbm")

--[=[
    @class NoiseLib

    Submodule for creating composable noise functions using monet.
]=]
return {
    fractalBrownian = fbm.fractalBrownian
}