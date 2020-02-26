//
//  MfArray_subscript.swift
//  MatftSample
//
//  Created by AM19A0 on 2019/11/11.
//  Copyright © 2019 jkado. All rights reserved.
//

import Foundation

extension MfArray{
    /*
     subscript(index: Int) -> MfArray<T>{
     precondition(self._shape.count > 1)
     }
     subscript(index: Int) -> T{
     
     }*/

    public subscript(indices: Int...) -> T{

        get {
            return self[indices]
        }
        set(newValue){
            self[indices] = newValue
        }
    }

    public subscript(indices: [Int]) -> T{

        get{
            precondition(indices.count == self.ndim, "cannot return value because given indices were invalid")
            let flattenIndex = _inner_product(indices, self.strides)

            precondition(flattenIndex < self.size, "indices \(indices) is out of bounds")
            return T.num((self.data + flattenIndex).pointee)
        }
        set(newValue){
            precondition(indices.count == self.ndim, "cannot return value because given indices were invalid")
            let flattenIndex = _inner_product(indices, self.strides)
            
            precondition(flattenIndex < self.size, "indices \(indices) is out of bounds")
            
            (self.data + flattenIndex).pointee = T.num(newValue)
        }
        
    }
    /*
     subscript(indices: Int...) -> MfArray<T>{
     precondition(indices.count > self._shape.count, "too many indices for array")
     
     }*/
    
    /*
     subscript(range: Range){
     
     }*/
}
