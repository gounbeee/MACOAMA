//
//  MathSubjectElement.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/28.
//

import SwiftUI
import RegexBuilder


// 1つのエレメントずつ持つView
struct MathSubjectElementView: View {
    
    
    @ObservedObject var ctr : MathSubjectController
    @ObservedObject var elmCtr : MathSubjectElementController
    
    @GestureState var locationStore = CGPoint(x: 0, y: 0)
    
    var sbjNo : Int = 0
    var pgNo : Int = 0
    
    
    
    
    init(controller: MathSubjectController, elmController: MathSubjectElementController, elementInfo: MathPageTextElm) {
        self.ctr = controller
        //self.elemIndex = elemIndex
        self.sbjNo = controller.subjectNo
        self.pgNo = controller.pageNo
        
        // エレメントのコントロールのエレメント本体は差し替え
        self.elmCtr = elmController
        self.elmCtr.element = elementInfo
        
        controller.elmCtr = elmController
        
        
        
    }
    
    

    var body: some View {
        
        
        Text( self.getStyledTokenizedString(inputTxt: self.elmCtr.element.content) )
            .background(Color(red: Double(self.elmCtr.element.bgColor.red)/255,
                              green: Double(self.elmCtr.element.bgColor.green)/255,
                              blue: Double(self.elmCtr.element.bgColor.blue)/255,
                              opacity: Double(self.elmCtr.element.bgColor.opacity)/255))
        
            .font(Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size))
            .foregroundColor(Color(red: Double(self.elmCtr.element.color.red)/255,
                                   green: Double(self.elmCtr.element.color.green)/255,
                                   blue: Double(self.elmCtr.element.color.blue)/255,
                                   opacity: Double(self.elmCtr.element.color.opacity)/255))
            .textSelection( .disabled )
            .lineSpacing(self.elmCtr.element.size * 0.2)
        
            .offset(x: self.elmCtr.element.position.x * Double(self.ctr.currentWindowWidthStr)!  + self.elmCtr.differPos.x  ,
                    y: self.elmCtr.element.position.y * Double(self.ctr.currentWindowHeightStr)! + self.elmCtr.differPos.y )
        //.frame(width: 500)
            .padding()
            .onHover { state in
                
                print("HOVERイベント発生!! -- \(state) ")
                
                if state == true {
                    delayTimer()
                }
                
            }
            .gesture(
                
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                
                // ドラッグする間、カーソルの次の位置を取得できる
                    .updating($locationStore) { currentState, pastLocation, transaction in
                        // print("----")
                        // print( "currentState.location IS  \(currentState.location)" )
                        // print( "pastLocation.location IS  \(pastLocation)" )
                        // print( "locationStore IS  \(locationStore)" )
                        
                        // ここで、新しい位置の情報を更新
                        pastLocation.x = currentState.location.x
                        pastLocation.y = currentState.location.y
                        
                        
                        transaction.animation = .easeInOut
                        
                    }
                
                    .onChanged { state in
                        
                        //print("---")
                        
                        // 最初にクリックした地点のピクセルの座標
                        //print( "state.startLocation IS  \(state.startLocation)" )
                        
                        // 現在の位置のピクセル座標
                        //print( "state.location IS  \(state.location)" )
                        
                        // 移動距離の差分
                        // state.startLocation + state.translation = state.location
                        //print( "state.translation IS   \(state.translation)")
                        
                        // 差分位置を計算
                        self.elmCtr.differPos.x = state.location.x - state.startLocation.x
                        self.elmCtr.differPos.y = state.location.y - state.startLocation.y
                        
                       
                        
                    }
                    .onEnded { state in
                        
                        
                        // 差分の比率を計算して更新
                        self.elmCtr.element.position.x += self.elmCtr.differPos.x / Double(self.ctr.currentWindowWidthStr)!
                        self.elmCtr.element.position.y += self.elmCtr.differPos.y / Double(self.ctr.currentWindowHeightStr)!
                        
                        // JSONドキュメントの情報も更新
                        // このページ内で検索
                        for index in 0...self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems.count-1 {
                            
                            // SEARCHING
                            // IDが同じであれば検索終了
                            if self.elmCtr.element.id == self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems[index].id {
                                //print("SEARCHED!")
                                
                                // 新しい位置に更新
                                self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems[index].position.x = self.elmCtr.element.position.x
                                self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems[index].position.y = self.elmCtr.element.position.y
                                self.elmCtr.isSelected = true
                                
                            } else {
                                
                                self.elmCtr.isSelected = false
                                
                            }
                            
                        }
                        
                        // 差分位置を初期化
                        // 差分の初期化は、JSONの更新に関わらず行うべき
                        self.elmCtr.differPos.x = 0
                        self.elmCtr.differPos.y = 0
                        
                        self.ctr.elmCtr!.isSelected = false
                        // JSON 更新とView更新を誘発
                        self.ctr.updateJsonAndReload()
                        
                    }
                
            )
        
    }
    
    
    // タイマーに関して
    // https://zenn.dev/toaster/articles/1084a55a66dc26
    func delayTimer() {
        
        var cnt = 0
        
        let timer = Timer
            .scheduledTimer(
                withTimeInterval: 0.25,
                repeats: true
            ) { _ in
                print("実行しました  --  \(cnt)")
                cnt += 1
                self.ctr.updateJsonAndReload()
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.invalidate()
        }
    }
    

    
    
    // ----------------------------------------------------------------------------------------------------------------
    
    
    // 以下の二つの関数で、文字を形態素解析をし、それらに個別のスタイリング施す
    
   
    
    func getStyledTokenizedString(inputTxt : String) -> AttributedString {
        
        let newInputTxt = checkLinkNumber(inputTxt: inputTxt)
        
        
        let txtProc = TextProcessor()
        
        txtProc.inputText = newInputTxt
        
        let arrayText : [String] = txtProc.tokenize(text: txtProc.inputText)
        
        var resultString : AttributedString = AttributedString("")
        
        
        let searchList = ["の","と","は","で","が","に","を"]
        
        
        for index in 0...arrayText.count-1 {
            
            var attributedString = AttributedString(arrayText[index])
            
            // ① まず、基本的な文字の変化を与える
            
            // サイズのランダム化
            attributedString.font = Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size * Double.random(in: 0.7...1.0))

            // カラーのランダム化
            attributedString.foregroundColor = Color(CGColor(red: Double.random(in: 0...0.6),
                                                             green: Double.random(in: 0...0.6),
                                                             blue: Double.random(in: 0...0.6),
                                                                 alpha: 1.0))
            
            // ② その後、接続詞はさらに変化させる
            
            for srcLetter in searchList {
                
                // AttributedStringを使用し、文字の部分をスタイリング
                // https://developer.apple.com/documentation/foundation/attributedstring
                // https://betterprogramming.pub/text-formatting-in-ios-and-swift-with-attributedstring-e821536fbdec
                // https://www.hackingwithswift.com/swift/5.7/regexes
                // https://bignerdranch.com/blog/swift-regex/
                
                
                if arrayText[index].contains(srcLetter) {
                    
                    
                    //print("\(srcLetter)  IS CONTAINED !!")
                    
                    if let range = attributedString.range(of: srcLetter) {
                        
                        //print(range.lowerBound)
                        //print("To")
                        //print(range.upperBound)
                        
                        // print(attributedString[range])
                        
                        
                        attributedString[range].foregroundColor = Color(CGColor(red: Double.random(in: 0.6...1.0),
                                                                         green: Double.random(in: 0...0.3),
                                                                         blue: Double.random(in: 0...0.3),
                                                                         alpha: 1.0))
                        
                        attributedString[range].font = Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size/1.3)
                    }
                    
                
                }

            }

            
            resultString += attributedString
            
        }
        
        return resultString
        
    }
    
    
    
    func checkLinkNumber(inputTxt : String) -> String {

        //  新しい正規表現の使用
        // https://blog.logrocket.com/getting-started-regexbuilder-swift/
        let search1 = Regex {
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
        }
        
        let search2 = Regex {
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
        }
        
        let search3 = Regex {
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
        }
        
        let search4 = Regex {
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            
        }
        
        let search5 = Regex {
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            
        }
        
        let search6 = Regex {
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            "->"
            Capture {
                ZeroOrMore(.digit)
            }
            "<-"
            ZeroOrMore(
                
                ChoiceOf {
                    CharacterClass(.word)
                    CharacterClass(.whitespace)
                    "の"
                    "と"
                    "は"
                    "で"
                    "が"
                    "に"
                    "を"
                    "、"
                    " "
                })
            
        }
        
        var resultTxt = inputTxt
        
        
        if let result = try? search1.wholeMatch(in: resultTxt) {
            
            //print(result.1)
            resultTxt = resultTxt.replacing(result.1, with:"")
            
            
        } else if let result = try? search2.wholeMatch(in: resultTxt) {
            
            //print(result.1)
            resultTxt = resultTxt.replacing(result.1, with:"")
            //print(result.2)
            resultTxt = resultTxt.replacing(result.2, with:"")
            
        } else if let result = try? search3.wholeMatch(in: resultTxt) {
            
            //print(result.1)
            resultTxt = resultTxt.replacing(result.1, with:"")
            //print(result.2)
            resultTxt = resultTxt.replacing(result.2, with:"")
            //print(result.3)
            resultTxt = resultTxt.replacing(result.3, with:"")
            
        } else if let result = try? search4.wholeMatch(in: resultTxt) {
            
            //print(result.1)
            resultTxt = resultTxt.replacing(result.1, with:"")
            //print(result.2)
            resultTxt = resultTxt.replacing(result.2, with:"")
            //print(result.3)
            resultTxt = resultTxt.replacing(result.3, with:"")
            //print(result.4)
            resultTxt = resultTxt.replacing(result.4, with:"")
            
        } else if let result = try? search5.wholeMatch(in: resultTxt) {
            
            //print(result.1)
            resultTxt = resultTxt.replacing(result.1, with:"")
            //print(result.2)
            resultTxt = resultTxt.replacing(result.2, with:"")
            //print(result.3)
            resultTxt = resultTxt.replacing(result.3, with:"")
            //print(result.4)
            resultTxt = resultTxt.replacing(result.4, with:"")
            //print(result.5)
            resultTxt = resultTxt.replacing(result.5, with:"")
            
        } else if let result = try? search6.wholeMatch(in: resultTxt) {
            
            //print(result.1)
            resultTxt = resultTxt.replacing(result.1, with:"")
            //print(result.2)
            resultTxt = resultTxt.replacing(result.2, with:"")
            //print(result.3)
            resultTxt = resultTxt.replacing(result.3, with:"")
            //print(result.4)
            resultTxt = resultTxt.replacing(result.4, with:"")
            //print(result.5)
            resultTxt = resultTxt.replacing(result.5, with:"")
            //print(result.6)
            resultTxt = resultTxt.replacing(result.6, with:"")
            
        }
        
        
        
        // 反復して検索、文字列を削除
        let replaced1 = resultTxt.replacing("->", with:"")
        let replaced2 = replaced1.replacing("<-", with:"")
        
        
        //print(replaced2)
        
        return replaced2
        
    }
    
    
}




