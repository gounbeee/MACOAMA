//
//  MathSubjectWindowController.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/13.
//

import Foundation
import AppKit
import SwiftUI




class MathSubjectWindowController : ObservableObject {
    
    
    var windowList : [NSWindow] = []
    var windowCount : Int = 0

    var windowListPos : [CGPoint] = []
    var windowListPosCenter : [CGPoint] = []
    var windowListSize : [CGSize] = []
    
    var arrowRotation : Double = 0.0
    
    
    
    
    func getCurrentMainWindowPosition() -> CGPoint {
   
        let result = calcCenterPoint(position: windowList[0].frame.origin, size: windowList[0].frame.size)
        print( result )
        
        return result
    }
    
    
    
    
    
    func calcDegreeBetweenTwoPoints() {

        //print("WINDOWの角度を計算しましょう！")
        let pointA = self.getCurrentMainWindowPosition()
        let pointB = self.windowListPosCenter[self.windowListPosCenter.count-1]
        //print(pointA)
        //print(pointB)
        
        
        let rad = self.makeDeltaAngle(targetPoint: pointB, center: pointA)

        self.arrowRotation = rad * 180.0 / Double.pi * -1.0
        //print(self.arrowRotation)
 
    }
    
    
    
    
    func addWindowToList ( window: NSWindow ) {
        
        self.windowList.append(window)
        self.windowListPos.append(window.frame.origin)
        self.windowListSize.append(window.frame.size)
        self.windowListPosCenter.append(self.calcCenterPoint(position: window.frame.origin, size: window.frame.size))
        
        self.windowCount += 1
        print( "現在のウィンドウの数は  \(self.windowCount)  です")
        //print(window)
        
        //print(window.contentView?.visibleRect)
        //print(window.contentRect(forFrameRect: NSRect(x: 100, y: 100, width: 250, height: 500)))
        
        //print(window.frame.origin)
        //print(window.frame.size)
        
    }
    
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    
    
    
    func calcCenterPoint(position: CGPoint, size: CGSize) -> CGPoint {
      
        return CGPoint(x: position.x + size.width/2, y: position.y + size.height/2)
        
    }
    
    
    func calcCenterPointRadian(fromPosition: CGPoint, fromSize: CGSize, toPosition: CGPoint, toSize: CGSize) -> Double {
        
        let fromCenterPoint = calcCenterPoint(position: fromPosition, size: fromSize)
        let toCenterPoint = calcCenterPoint(position: toPosition, size: toSize)
                
        return self.getAngleRad(pointA: fromCenterPoint, pointB: toCenterPoint)
                
    }
    
    
    
    func getAngleRad(pointA: CGPoint, pointB: CGPoint) -> Double {
        var r = atan2(pointB.y - pointA.y, pointB.x - pointA.x)
        if r < 0 {
            r = r + 2 * Double.pi
        }
        return floor(r * 360 / (2 * Double.pi))
    }
    
    // CoordinateManager.swift
    func makeDeltaAngle(targetPoint: CGPoint, center: CGPoint) -> CGFloat {
        // 中心点を座標の(0, 0)に揃える
        let dx = targetPoint.x - center.x
        let dy = targetPoint.y - center.y
        // 座標と中心の角度を返却
        return atan2(dy, dx)
    }
    
    
    func calculateDistance(center: CGPoint, point: CGPoint) -> CGFloat {
        let dx = point.x - center.x
        let dy = point.y - center.y
        return CGFloat(sqrt(dx*dx + dy*dy)) //ピタゴラスの定理より
    }
    
}









