//
//  MathSubjectEditView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/03.
//

import SwiftUI





struct MathSubjectEditView: View {
    
    @State private var subjectAllCount : Int = 0
    @State private var pageAllCount : Int = 0
    @State private var currentElemId : String = "initial"
    @State private var currentElemPosX : String = "0.0"
    @State private var currentElemPosY : String = "0.0"
    
    @State private var currentElemColorR : String = "0.0"
    @State private var currentElemColorG : String = "0.0"
    @State private var currentElemColorB : String = "0.0"
    @State private var currentElemColorO : String = "0.0"
    
    @State private var currentElemBgColorR : String = "0.0"
    @State private var currentElemBgColorG : String = "0.0"
    @State private var currentElemBgColorB : String = "0.0"
    @State private var currentElemBgColorO : String = "0.0"
    
    @State private var currentElemFontSize : String = "50.0"
    @State private var currentElemFontName : String = "initial"
    @State private var currentElemContent : String = "initial"
    @State private var currentElemTimeIn : String = "0.0"
    @State private var currentElemTimeOut : String = "0.0"
    
    
    @State var parsedJson : MathSubjectResponse? = nil
    
    @State private var mathSubjectNo = 0
    @State private var mathPageNo = 0
    
    @State private var mathPage : MathPage? = nil
    
    
    init(controller: MathSubjectController) {
        
        // 初期化時の下線の意味
        // https://stackoverflow.com/questions/65209314/what-does-the-underscore-mean-before-a-variable-in-swiftui-in-an-init
        self.parsedJson = controller.jsonObj
        
        self.mathSubjectNo = controller.subjectNo
        self.mathPageNo = controller.pageNo
        
        self.mathPage = controller.jsonObj!.subjects[self.mathSubjectNo].pages[self.mathPageNo]
            
        
        if self.mathPage != nil {
            
            self.currentElemId = self.mathPage!.textElems.first!.id
            self.currentElemPosX = String(self.mathPage!.textElems.first!.position.x)
            self.currentElemPosY = String(self.mathPage!.textElems.first!.position.y)
            
            self.currentElemColorR = String(self.mathPage!.textElems.first!.color.red)
            self.currentElemColorG = String(self.mathPage!.textElems.first!.color.green)
            self.currentElemColorB = String(self.mathPage!.textElems.first!.color.blue)
            self.currentElemColorO = String(self.mathPage!.textElems.first!.color.opacity)
            
            self.currentElemBgColorR = String(self.mathPage!.textElems.first!.bgColor.red)
            self.currentElemBgColorG = String(self.mathPage!.textElems.first!.bgColor.green)
            self.currentElemBgColorB = String(self.mathPage!.textElems.first!.bgColor.blue)
            self.currentElemBgColorO = String(self.mathPage!.textElems.first!.bgColor.opacity)
            
            self.currentElemFontSize = self.mathPage!.textElems.first!.size.formatted()
            self.currentElemFontName = self.mathPage!.textElems.first!.font
            
            self.currentElemContent = self.mathPage!.textElems.first!.content
            
            self.currentElemTimeIn = self.mathPage!.textElems.first!.timeIn.formatted()
            self.currentElemTimeOut = self.mathPage!.textElems.first!.timeOut.formatted()
            
            
        }
        
        
            
            
            
        
        
        
        //print( self.parsedJson. )
        
    }
    
    
    
    var body: some View {
        
        VStack {
            HStack {
                
                Spacer()
                
                HStack {
                    
                    Text("全体Subject数")
                    Text(String(self.subjectAllCount))
                    
                }

                
                Divider()
                
                Spacer()
                
                
                HStack {
                    Text("全体Page数")
                    Text(String(self.pageAllCount))
                }

                
            }
            .frame(height: 30)
            
            Divider()
            

            
            HStack {
                Form {
                    TextField(text: $currentElemId, prompt: Text("enter elem id")) {
                        Text("ID")
                    }
                    TextField(text: $currentElemFontName, prompt: Text("enter font name") ) {
                        Text("Font")
                    }
                    TextField(text: $currentElemFontSize, prompt: Text("enter font size") ) {
                        Text("FontSz")
                    }
                    TextField(text: $currentElemContent, prompt: Text("enter elem content") ) {
                        Text("Content")
                    }
                }
            }
            
            Divider()
            
            
            HStack {
                Form {
             
                    TextField(text: $currentElemPosX, prompt: Text("enter position X") ) {
                        Text("PosX")
                    }
                    TextField(text: $currentElemPosY, prompt: Text("enter position Y") ) {
                        Text("PosY")
                    }
                    
                }
            }
                
            Divider()
            
            HStack {
                Form {
                    
                    TextField(text: $currentElemColorR, prompt: Text("enter Text Color R") ) {
                        Text("ColR")
                    }
                    TextField(text: $currentElemColorG, prompt: Text("enter Text Color G") ) {
                        Text("ColG")
                    }
                    TextField(text: $currentElemColorB, prompt: Text("enter Text Color B") ) {
                        Text("ColB")
                    }
                    TextField(text: $currentElemColorO, prompt: Text("enter Text Color O") ) {
                        Text("ColO")
                    }
                }
            }
            
            Divider()
            
            HStack {
                Form {
                    TextField(text: $currentElemBgColorR, prompt: Text("enter Text BgColor R") ) {
                        Text("ColBgR")
                    }
                    TextField(text: $currentElemBgColorG, prompt: Text("enter Text BgColor G") ) {
                        Text("ColBgG")
                    }
                    TextField(text: $currentElemBgColorB, prompt: Text("enter Text BgColor B") ) {
                        Text("ColBgB")
                    }
                    TextField(text: $currentElemBgColorO, prompt: Text("enter Text BgColor O") ) {
                        Text("ColBgO")
                    }
                }
            }
            
            
        }
        .frame(alignment: .topLeading)
        .padding()
        
        
        
        
        
    }
    
    
    
    
    
}




//struct MathSubjectEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MathSubjectEditView()
//    }
//}
