//
//  MoveControllerDelegate.swift
//  Objects
//
//  Created by Lesha Miroshnik on 4/10/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation
import UIKit

protocol MoveControllerDelegate {
    func touchShapeBegan(withTouches touches: Set<UITouch>, andEvent event: UIEvent?, andShape shape: Shape)
}
