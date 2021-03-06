//
//  File.swift
//  
//
//  Created by AM19A0 on 2020/05/11.
//

import Foundation

internal func get_axis(_ axis: Int, ndim: Int) -> Int{
    let ret_axis = axis >= 0 ? axis : axis + ndim
    precondition(0 <= ret_axis && ret_axis < ndim, "\(axis) is out of bounds")
    
    return ret_axis
}

internal func get_index(_ index: Int, dim: Int, axis: Int) -> Int{
    let ret_index = index >= 0 ? index : index + dim
    precondition(0 <= ret_index && ret_index < dim, "\(index) is out of bounds for axis \(axis) with \(dim)")
    
    return ret_index
}

internal func get_shape(_ shape: [Int], _ size: Int) -> [Int]{
    let restsize = shape.filter{ $0 != -1 }.reduce(1, *)
    return shape.map{
        if $0 != -1{
            return $0
        }
        else{
            return size / restsize
        }
    }
}
