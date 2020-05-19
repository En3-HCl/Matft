//
//  File 2.swift
//  
//
//  Created by β α on 2020/05/19.
//

import Foundation


extension Matft.mfarray{
    public enum random{}
}

extension Matft.mfarray.random{
    /**
       Create random value's mfarray from 0 to 1
       - parameters:
            - shape: shape
            - mftype: the type of mfarray
            - order: (Optional) order, default is nil, which means close to row major
    */
    static public func rand(shape: [Int], mftype: MfType, mforder: MfOrder = .Row) -> MfArray{
        var shape = shape
        let size = shape.withUnsafeMutableBufferPointer{
            shape2size($0)
        }
        
        let retmftype = mftype
        let newmfdata = withDummyDataMRPtr(retmftype, storedSize: size){
            ptr in
            switch MfType.storedType(retmftype){
            case .Float:
                var arr = Array(repeating: Float.zero, count: size).map{_ in Float.random(in: 0..<1)}
                let ptrF = ptr.bindMemory(to: Float.self, capacity: size)
                arr.withUnsafeMutableBufferPointer{
                    ptrF.moveAssign(from: $0.baseAddress!, count: size)
                }
            case .Double:
                var arr = Array(repeating: Double.zero, count: size).map{_ in Double.random(in: 0..<1)}
                let ptrD = ptr.bindMemory(to: Double.self, capacity: size)
                arr.withUnsafeMutableBufferPointer{
                    ptrD.moveAssign(from: $0.baseAddress!, count: size)
                }
            }

        }
        
        let retndim = shape.count
        let newmfstructure = withDummyShapeStridesMBPtr(retndim){
            shapeptr, stridesptr in
            shape.withUnsafeMutableBufferPointer{
                shapeptr.baseAddress!.moveAssign(from: $0.baseAddress!, count: retndim)
            }
            
            let newstrides = shape2strides(shapeptr, mforder: .Row)
            stridesptr.baseAddress!.moveAssign(from: newstrides.baseAddress!, count: retndim)
            
            newstrides.deallocate()
        }
        
        return MfArray(mfdata: newmfdata, mfstructure: newmfstructure)
    }
    
    
    /**
       Create random integer's mfarray from low to high
       - parameters:
            - low: minimum value
            - high: maximum value
            - shape: shape
            - order: (Optional) order, default is nil, which means close to row major
    */

    static public func randint(low:Int = 0, high:Int, shape: [Int], mforder: MfOrder = .Row) -> MfArray{
        var shape = shape
        let size = shape.withUnsafeMutableBufferPointer{
            shape2size($0)
        }
        
        let retmftype:MfType = .Float
        let newmfdata = withDummyDataMRPtr(retmftype, storedSize: size){
            ptr in
            var arr = Array(repeating: Float.zero, count: size).map{_ in Float(Int.random(in: low..<high))}
            let ptrF = ptr.bindMemory(to: Float.self, capacity: size)
            arr.withUnsafeMutableBufferPointer{
                ptrF.moveAssign(from: $0.baseAddress!, count: size)
            }
        }
        
        let retndim = shape.count
        let newmfstructure = withDummyShapeStridesMBPtr(retndim){
            shapeptr, stridesptr in
            shape.withUnsafeMutableBufferPointer{
                shapeptr.baseAddress!.moveAssign(from: $0.baseAddress!, count: retndim)
            }
            
            let newstrides = shape2strides(shapeptr, mforder: .Row)
            stridesptr.baseAddress!.moveAssign(from: newstrides.baseAddress!, count: retndim)
            
            newstrides.deallocate()
        }
        
        return MfArray(mfdata: newmfdata, mfstructure: newmfstructure)
    }
}
