//
//  infix.swift
//  Matft
//
//  Created by AM19A0 on 2020/02/28.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation

public func +(l_mfarray: MfArray, r_mfarray: MfArray) -> MfArray{
    Matft.mfarray.add(l_mfarray, r_mfarray)
}
public func -(l_mfarray: MfArray, r_mfarray: MfArray) -> MfArray{
    Matft.mfarray.sub(l_mfarray, r_mfarray)
}
public func *(l_mfarray: MfArray, r_mfarray: MfArray) -> MfArray{
    Matft.mfarray.mul(l_mfarray, r_mfarray)
}
public func /(l_mfarray: MfArray, r_mfarray: MfArray) -> MfArray{
    Matft.mfarray.div(l_mfarray, r_mfarray)
}
