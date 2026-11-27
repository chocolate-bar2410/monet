export type KdNode = { left: KdNode?, right: KdNode?, value: vector,axis: number }

export type KdTree = setmetatable<{
    root: KdNode
    },{
    __index: {
        closest: (self: KdTree, index: vector) -> vector
    }
}>

return nil