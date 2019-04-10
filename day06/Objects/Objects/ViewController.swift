//
//  ViewController.swift
//  Objects
//
//  Created by Lesha Miroshnik on 4/9/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var shapes: [Shape] = []
    var colors: [UIColor] = [.red, .blue, .yellow, .green, .orange]
    
    var motionManager = CMMotionManager()
    var animator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTapGesture = UITapGestureRecognizer(target: self, action: #selector(tochesGesture(_:)))
        theTapGesture.delegate = self
        view.addGestureRecognizer(theTapGesture)
        view.isUserInteractionEnabled = true
        animator = UIDynamicAnimator(referenceView: view)
        gravityBehavior = UIGravityBehavior()
        collisionBehavior = UICollisionBehavior()
        dynamicItemBehaviour = UIDynamicItemBehavior()
        dynamicItemBehaviour.elasticity = 0.6
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(dynamicItemBehaviour)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: handleAccelerometerUpdate(data:error:))
        }
    }
    
    func handleAccelerometerUpdate(data: CMAccelerometerData?, error: Error?) -> Void {
        guard let theData = data else { return }
        gravityBehavior.gravityDirection = CGVector(dx: theData.acceleration.x, dy: -theData.acceleration.y)
    }
    
    @IBAction func tochesGesture(_ sender: UITapGestureRecognizer) {
        for shape in shapes {
            if shape.frame.contains(sender.location(in: view)) {
                return
            }
        }
        
        let theLocation = sender.location(in: self.view)
        var theNewXLocation = theLocation.x - 50
        var theNewYLocation = theLocation.y - 50
        if theNewXLocation < 50 {
            theNewXLocation = 0
        } else if theNewXLocation > view.frame.size.width - 100 {
            theNewXLocation = view.frame.size.width - 100
        }
        if theNewYLocation < 50 {
            theNewYLocation = 0
        } else if theNewYLocation > view.frame.size.height - 100 {
            theNewYLocation = view.frame.size.height - 100
        }
        let theColor = self.colors[Int(arc4random()) % self.colors.count]
        let theSquare = Int(arc4random()) % 2
        let theNewShape = Shape(withCoordinateX: theNewXLocation, withCoordinateY: theNewYLocation, isSquare: theSquare == 1 ? true : false, withColor: theColor)
        
        shapes.append(theNewShape)
        
        let thePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(movingShape(withPanGesture:)))
        let theZoomRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoomingShape(withPinchGesture:)))
        let theRotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotatingShape(withRotationGesture:)))
        
        thePanRecognizer.delegate = self
        theZoomRecognizer.delegate = self
        theRotateRecognizer.delegate = self
        
        theNewShape.addGestureRecognizer(thePanRecognizer)
        theNewShape.addGestureRecognizer(theZoomRecognizer)
        theNewShape.addGestureRecognizer(theRotateRecognizer)
        
        theNewShape.delegate = self
        theNewShape.isUserInteractionEnabled = true
        
        view.addSubview(theNewShape)
        
        gravityBehavior.addItem(theNewShape)
        collisionBehavior.addItem(theNewShape)
        dynamicItemBehaviour.addItem(theNewShape)
    }
    
}

extension ViewController {
    
    @IBAction func movingShape(withPanGesture gesture: UIPanGestureRecognizer) {
        guard let theView = gesture.view as? Shape else { return }
        switch gesture.state {
        case .began:
            gravityBehavior.removeItem(theView)
        case .changed:
            collisionBehavior.removeItem(theView)
            dynamicItemBehaviour.removeItem(theView)
            let gestureCenter = gesture.location(in: view)
            theView.center = gestureCenter
            collisionBehavior.addItem(theView)
            dynamicItemBehaviour.addItem(theView)
            animator.updateItem(usingCurrentState: theView)
        case .ended, .cancelled, .failed:
            gravityBehavior.addItem(theView)
        default:
            break
        }
    }
    
    @IBAction func zoomingShape(withPinchGesture gesture: UIPinchGestureRecognizer) {
        guard gesture.numberOfTouches >= 2 else { return }
        guard let theView = gesture.view as? Shape else { return }
        switch gesture.state {
        case .began:
            gravityBehavior.removeItem(theView)
        case .changed:
            collisionBehavior.removeItem(theView)
            dynamicItemBehaviour.removeItem(theView)
            theView.bounds.size.width = theView.saveBounds.width * gesture.scale
            theView.bounds.size.height = theView.saveBounds.height * gesture.scale
            if theView.isSquare == false {
                theView.layer.cornerRadius = min(theView.bounds.size.width, theView.bounds.size.height) / 2.0
            }
            collisionBehavior.addItem(theView)
            dynamicItemBehaviour.addItem(theView)
            animator.updateItem(usingCurrentState: theView)
        case .ended, .cancelled, .failed:
            theView.saveBounds = theView.bounds
            gravityBehavior.addItem(theView)
        default:
            break
        }
    }
    
    @IBAction func rotatingShape(withRotationGesture gesture: UIRotationGestureRecognizer) {
        guard gesture.numberOfTouches >= 2 else { return }
        guard let theView = gesture.view as? Shape else { return }
        switch gesture.state {
        case .began:
            gravityBehavior.removeItem(theView)
        case .changed:
            collisionBehavior.removeItem(theView)
            dynamicItemBehaviour.removeItem(theView)
            theView.transform = theView.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
            collisionBehavior.addItem(theView)
            dynamicItemBehaviour.addItem(theView)
            animator.updateItem(usingCurrentState: theView)
        case .ended, .cancelled, .failed:
            gravityBehavior.addItem(theView)
        default:
            break
        }
    }
    
}


extension ViewController: MoveControllerDelegate {
    func touchShapeBegan(withTouches touches: Set<UITouch>, andEvent event: UIEvent?, andShape shape: Shape) {
        view.bringSubviewToFront(shape)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
