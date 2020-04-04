//
//  vecLib.swift
//  Matft
//
//  Created by AM19A0 on 2020/03/04.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation
import Accelerate

internal typealias vForce_vv_func<T> = (UnsafeMutablePointer<T>, UnsafePointer<T>, UnsafePointer<Int32>) -> Void

internal func math_vv_by_vForce<T: MfTypable, U: MfStorable>(_ mfarray: MfArray<T>, _ vForce_func: vForce_vv_func<U>) -> MfArray<T>{
    var mfarray = mfarray
    if !(mfarray.mfflags.column_contiguous || mfarray.mfflags.row_contiguous){//neither row nor column contiguous, close to row major
        mfarray = to_row_major(mfarray)
    }
    
    let newdata = withDummyDataMRPtr(mfarray.mftype, storedSize: mfarray.storedSize){
        dstptr in
        let dstptrT = dstptr.bindMemory(to: T.self, capacity: mfarray.storedSize)
        mfarray.withDataUnsafeMBPtrT(datatype: T.self){
            [unowned mfarray] in
            var storedSize = Int32(mfarray.storedSize)
            vForce_func(dstptrT, $0.baseAddress!, &storedSize)
        }
    }
    
    let newmfstructure = copy_mfstructure(mfarray.mfstructure)
    return MfArray(mfdata: newdata, mfstructure: newmfstructure)
}

internal typealias vForce_1arg_vv_func<T> = (UnsafeMutablePointer<T>, UnsafePointer<T>, UnsafePointer<T>, UnsafePointer<Int32>) -> Void

internal func math_1arg_vv_by_vForce<T: MfTypable, U: MfStorable>(_ mfarray: MfArray<T>, _ arg: UnsafePointer<U>, _ vForce_func: vForce_1arg_vv_func<U>) -> MfArray<T>{
    var mfarray = mfarray
    if !(mfarray.mfflags.column_contiguous || mfarray.mfflags.row_contiguous){//neither row nor column contiguous, close to row major
        mfarray = to_row_major(mfarray)
    }
    
    let newdata = withDummyDataMRPtr(mfarray.mftype, storedSize: mfarray.storedSize){
        dstptr in
        let dstptrT = dstptr.bindMemory(to: T.self, capacity: mfarray.storedSize)
        mfarray.withDataUnsafeMBPtrT(datatype: T.self){
            [unowned mfarray] in
            var storedSize = Int32(mfarray.storedSize)
            vForce_func(dstptrT, $0.baseAddress!, arg, &storedSize)
        }
    }
    
    let newmfstructure = copy_mfstructure(mfarray.mfstructure)
    return MfArray(mfdata: newdata, mfstructure: newmfstructure)
}
