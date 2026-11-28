export type KdNode = { left: KdNode?, right: KdNode?, value: vector,axis: number }

export type KdTree = setmetatable<{
    root: KdNode?
    },{
    __index: {
        closest: (self: KdTree, index: vector) -> vector,
        addPoint: (self: KdTree, value: vector) -> (),
        removePoint: (self: KdTree, value: vector) -> ()
    }
}>

export type noise_fn = (x: number, y: number) -> Colour4

return nil