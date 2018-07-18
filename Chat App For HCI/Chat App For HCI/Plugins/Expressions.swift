//
//  Expressions.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 7/7/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class Expression: NSObject {
    func name() -> String {
        return ""
    }
    func isExpressing(from: ARFaceAnchor) -> Bool {
        // should return true when the ARFaceAnchor is performing the expression we want
        return false
    }
    func isDoingWrongExpression(from: ARFaceAnchor) -> Bool {
        // should return true when the ARFaceAnchor is performing the WRONG expression from what we want. for example, if the expression is "Blink Left", then this should return true if the user's right eyelid is also closed.
        return false
    }
}


class SmileExpression: Expression {
    override func name() -> String {
        return "Smile :)"
    }
    override func isExpressing(from: ARFaceAnchor) -> Bool {
        guard let smileLeft = from.blendShapes[.mouthSmileLeft], let smileRight = from.blendShapes[.mouthSmileRight] else {
            return false
        }
        
        // from testing: 0.5 is a lightish smile, and 0.9 is an exagerrated smile
        return smileLeft.floatValue > 0.5 && smileRight.floatValue > 0.5
    }
}

class FrownExpression: Expression {
    override func name() -> String {
        return "Frown :("
    }
    override func isExpressing(from: ARFaceAnchor) -> Bool {
        guard let frownLeft = from.blendShapes[.mouthFrownLeft], let frownRight = from.blendShapes[.mouthFrownRight] else {
            return false
        }
        
        return frownLeft.floatValue > 0.5 && frownRight.floatValue > 0.5
    }
}

class SurpriseExpression: Expression {
    override func name() -> String {
        return "Be Surprised :O"
    }
    override func isExpressing(from: ARFaceAnchor) -> Bool {
        guard let jawOpen = from.blendShapes[.jawOpen], let browInnerUp = from.blendShapes[.browInnerUp] else {
            return false
        }
        
        return jawOpen.floatValue > 0.7 || browInnerUp.doubleValue > 0.7
    }
}

class AngerExpression: Expression {
    override func name() -> String {
        return "Be Angry >:|"
    }
    override func isExpressing(from: ARFaceAnchor) -> Bool {
        guard let browOuterUpLeft = from.blendShapes[.browOuterUpLeft], let browOuterUpRight = from.blendShapes[.browOuterUpRight] else {
            return false
        }
        
        return browOuterUpLeft.doubleValue > 0.7 && browOuterUpRight.doubleValue > 0.7
    }
}

class CheekPuffExpression: Expression {
    override func name() -> String {
        return "Puff Cheeks <('O')>"
    }
    override func isExpressing(from: ARFaceAnchor) -> Bool {
        guard let cheekPuff = from.blendShapes[.cheekPuff] else {
            return false
        }
        
        // from testing: 0.4 is mid-level puff; 0.7 is high intensity puff
        return cheekPuff.doubleValue > 0.4
    }
}
