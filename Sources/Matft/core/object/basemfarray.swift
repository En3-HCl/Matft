//
//  File.swift
//  
//
//  Created by Junnosuke Kado on 2020/04/04.
//

import Foundation

class BaseMfArray<MfType: MfTypable>: ExpressibleByBaseMfarrayLiteral{
    required init(flattenArray: inout [MfType], shape: inout [Int]) {
        
    }
    
    typealias ArrayLiteralElement = MfType
    
 // Only setter is private
    public internal(set) var mfstructure: MfStructure
    
    required init(arrayLiteral elements: MfType...) {
        
    }
}

internal protocol ExpressibleByBaseMfarrayLiteral: ExpressibleByArrayLiteral {
    init(flattenArray: inout [ArrayLiteralElement], shape: inout [Int])
}
