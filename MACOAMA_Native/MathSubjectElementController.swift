//
//  MathSubjectElementController.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/07.
//

import Foundation
import SwiftUI


class MathSubjectElementController : ObservableObject{
    
    @Published var differPos = CGPoint(x: 0, y: 0)
    
    @Published var isSelected : Bool = false

    @Published var element : MathPageTextElm = MathPageTextElm(id: "initial",
                                                     font: "initial",
                                                     content: "initial",
                                                     size: 60.0,
                                                     position: MathPosition(x: 0.0, y: 0.0),
                                                     color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                     bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                     timeIn: 0, timeOut: 0)
    
}

