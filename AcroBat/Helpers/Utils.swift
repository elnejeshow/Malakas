//
//  Utils.swift
//  AcroBat
//
//  Created by Walter Purcaro on 13/06/2018.
//  Copyright © 2018 Malakas Team. All rights reserved.
//

import UIKit

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}
