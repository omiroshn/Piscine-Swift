//
//  Shape.swift
//  Objects
//
//  Created by Lesha Miroshnik on 4/10/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class Shape: UIView, UIGestureRecognizerDelegate {
    var delegate: MoveControllerDelegate?
    let isSquare: Bool
    let color: UIColor
    var saveBounds: CGRect!
    
    init(withCoordinateX coordinateX: CGFloat, withCoordinateY coordinateY: CGFloat, isSquare square: Bool, withColor color: UIColor) {
        
        self.isSquare = square
        self.color = color
        let theRect = CGRect(x: coordinateX, y: coordinateY, width: 100, height: 100)
        self.saveBounds = theRect
        super.init(frame: theRect)
        self.backgroundColor = color
        if self.isSquare == false {
            self.layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchShapeBegan(withTouches: touches, andEvent: event, andShape: self)
    }
}
