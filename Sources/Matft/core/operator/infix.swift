//
//  infix.swift
//  Matft
//
//  Created by AM19A0 on 2020/02/28.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation

public func +<T: MfTypable>(l_mfarray: MfArray<T>, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.add(l_mfarray, r_mfarray)
}
public func +<T: MfTypable>(l_mfarray: MfArray<T>, r_scalar: T) -> MfArray<T>{
    return Matft.mfarray.add(l_mfarray, r_scalar)
}
public func +<T: MfTypable>(l_scalar: T, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.add(l_scalar, r_mfarray)
}

public func -<T: MfTypable>(l_mfarray: MfArray<T>, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.sub(l_mfarray, r_mfarray)
}
public func -<T: MfTypable>(l_mfarray: MfArray<T>, r_scalar: T) -> MfArray<T>{
    return Matft.mfarray.sub(l_mfarray, r_scalar)
}
public func -<T: MfTypable>(l_scalar: T, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.sub(l_scalar, r_mfarray)
}

public func *<T: MfTypable>(l_mfarray: MfArray<T>, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.mul(l_mfarray, r_mfarray)
}
public func *<T: MfTypable>(l_mfarray: MfArray<T>, r_scalar: T) -> MfArray<T>{
    return Matft.mfarray.mul(l_mfarray, r_scalar)
}
public func *<T: MfTypable>(l_scalar: T, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.mul(l_scalar, r_mfarray)
}

public func /<T: MfTypable>(l_mfarray: MfArray<T>, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.div(l_mfarray, r_mfarray)
}
public func /<T: MfTypable>(l_mfarray: MfArray<T>, r_scalar: T) -> MfArray<T>{
    return Matft.mfarray.div(l_mfarray, r_scalar)
}
public func /<T: MfTypable>(l_scalar: T, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.div(l_scalar, r_mfarray)
}

public func ===<T: MfTypable>(l_mfarray: MfArray<T>, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.equal(l_mfarray, r_mfarray)
}

extension MfArray: Equatable{
    public static func == (lhs: MfArray, rhs: MfArray) -> Bool {
        return Matft.mfarray.allEqual(lhs, rhs)
    }
}

infix operator *&: MultiplicationPrecedence //matmul
public func *&<T: MfTypable>(l_mfarray: MfArray<T>, r_mfarray: MfArray<T>) -> MfArray<T>{
    return Matft.mfarray.matmul(l_mfarray, r_mfarray)
}
