//
//  MathSubjectLinkController.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/12.
//

import Foundation
import AppKit


class MathSubjectLinkController : ObservableObject {
    
    //var screenSize = (NSScreen.main?.visibleFrame.size)!
    
    var wndXPos: Double = Double.random(in: 0.0...NSScreen.main!.visibleFrame.size.width)
    var wndYPos: Double = Double.random(in: 0.0...NSScreen.main!.visibleFrame.size.height)
    
    var wndWidth  : Int = Int(MathSubjectController.ElementWidth / 2)
    var wndHeight : Int = Int(MathSubjectController.ElementHeight / 2)
    
    var subjectNo : Int = 0

    
    
}
