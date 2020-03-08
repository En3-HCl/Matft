//
//  offset.swift
//  Matft
//
//  Created by Junnosuke Kado on 2020/03/07.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation

internal struct OptOffsetParams: Sequence{
    let bigger_mfarray: MfArray
    let smaller_mfarray: MfArray
    
    public init(bigger_mfarray: MfArray, smaller_mfarray: MfArray){
        self.bigger_mfarray = bigger_mfarray
        self.smaller_mfarray = smaller_mfarray
    }
    
    func makeIterator() -> OptOffsetParamIterator {
        return OptOffsetParamIterator(optParams: self)
    }
}

internal struct OptOffsetParamIterator: IteratorProtocol{
    let stride: (b: Int, s: Int)
    let blocksize: Int
    let itershapes: [Int]
    let iter_strides: (b: [Int], s: [Int])
    
    var upaxis: Int //indicates which axis will be counted up
    var indicesOfAxes: [Int]
    var offset: (b: Int, s: Int)?
    
    public init(optParams: OptOffsetParams){
        let (axis, blocksize, iterAxes) = _optStrides(shapeptr: optParams.bigger_mfarray.shapeptr, l_strideptr: optParams.bigger_mfarray.stridesptr, r_strideptr: optParams.smaller_mfarray.stridesptr)
        
        self.stride.b = optParams.bigger_mfarray.stridesptr[axis]
        self.stride.s = optParams.smaller_mfarray.stridesptr[axis]
        self.blocksize = blocksize
        
        self.itershapes = iterAxes.map{ optParams.bigger_mfarray.shapeptr[$0] }
        self.iter_strides.b = iterAxes.map{ optParams.bigger_mfarray.stridesptr[$0] }
        self.iter_strides.s = iterAxes.map{ optParams.smaller_mfarray.stridesptr[$0] }
        
        
        if self.itershapes.isEmpty{
            self.upaxis = -1
            self.indicesOfAxes = []
        }
        else{
            self.upaxis = 0
            self.indicesOfAxes = Array(repeating: 0, count: self.itershapes.count)
        }
        self.offset = (0, 0)
    }
    
    mutating func next() -> (b_offset: Int, b_stride: Int, s_offset: Int, s_stride: Int, blocksize: Int)? {
        if self.indicesOfAxes.isEmpty{//offset (0, 0) must be returned even if itershapes doesn't exist
            
            self.indicesOfAxes = [-1] //dummy
            return (self.offset!.b, self.stride.b, self.offset!.s, self.stride.s, self.blocksize)
        }
        
        if self.upaxis < 0{
            return nil
        }

        for axis in 0..<self.indicesOfAxes.count{
            if self.indicesOfAxes[axis] < self.itershapes[axis] - 1{
                self.indicesOfAxes[axis] += 1
                self.upaxis = axis
                
                self.offset!.b += self.iter_strides.b[axis]
                self.offset!.s += self.iter_strides.s[axis]
                
                return (self.offset!.b, self.stride.b, self.offset!.s, self.stride.s, self.blocksize)
            }
            else if self.upaxis < self.itershapes.count{// next axis
                self.indicesOfAxes[axis] = 0

                // reset offset
                self.offset!.b -= self.iter_strides.b[axis]*(self.itershapes[axis] - 1)
                self.offset!.s -= self.iter_strides.s[axis]*(self.itershapes[axis] - 1)
            }
            else{
                return nil
            }
        }
        
        //last all indices are 0
        self.upaxis = -1
        return (self.offset!.b, self.stride.b, self.offset!.s, self.stride.s, self.blocksize)
    }
}

/*
 * search maximum and common contiguous stride between two mfarray
 * @return
 *      axis        : index of strides given for vDSP
 *      blocksize   : maximum size calculated once by vDSP
 *      iterAxes    : indices of non-contiguous strides
 */
fileprivate func _optStrides(shapeptr: UnsafeMutableBufferPointer<Int>, l_strideptr: UnsafeMutableBufferPointer<Int>, r_strideptr: UnsafeMutableBufferPointer<Int>) -> (axis: Int, blocksize: Int, iterAxes: [Int]){
    var optaxis = 0, optBlockSize = -1
    
    let ndim = shapeptr.count
    var optiterAxes: [Int] = Array(0..<ndim)
    
    // search optimimal strides
    for axis in 0..<ndim{
        var l_strides = Array(l_strideptr) as [Int?]
        var r_strides = Array(r_strideptr) as [Int?]
        l_strides[axis] = nil//flag for skip
        r_strides[axis] = nil
        
        var n = 0
        var last_contiguous_axis = axis
        var blockSize = shapeptr[axis]
        var iterAxes: [Int] = []
        while n < ndim{
            guard let lst = l_strides[n], let rst = r_strides[n] else {//skip
                n += 1
                continue
            }
            
            if (lst == l_strideptr[last_contiguous_axis] * shapeptr[last_contiguous_axis]) && (rst == r_strideptr[last_contiguous_axis] * shapeptr[last_contiguous_axis]){//
                l_strides[n] = nil//set flag as already checked
                r_strides[n] = nil
                
                //update blocksize
                blockSize *= shapeptr[n]
                
                //update last_contiguous_axis
                last_contiguous_axis = n
                
                //re-search
                n = 0
                iterAxes = []
                
                continue
            }
            
            //set axes to search
            iterAxes.append(n)
            n += 1
        }
        
        //check if it is maximum blocksize or not
        if blockSize > optBlockSize{
            optBlockSize = blockSize
            optaxis = axis
            optiterAxes = iterAxes
        }
    }
    
    return (optaxis, optBlockSize, optiterAxes)
}