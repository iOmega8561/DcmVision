//
//  Entity.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 23/04/25.
//

import RealityKit

extension Entity {
    
    func setDirectGestures(enabled: Bool) {
        
        self.gestureComponent?.canDrag = enabled
        self.gestureComponent?.canRotate = enabled
        self.gestureComponent?.canScale = enabled
        self.gestureComponent?.pivotOnDrag = enabled
        self.gestureComponent?.preserveOrientationOnPivotDrag = enabled
    }
}
