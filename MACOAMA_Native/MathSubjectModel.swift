//
//  MathSubjects.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/22.
//

import Foundation



enum MathPageType : String, Decodable {
    
    case text = "text"
    case graphic = "graphic"
    
}


struct MathPosition : Decodable, Hashable {
    
    var x : Double
    var y : Double
    
    // 座標は、様々なフォーマット（分かれている、配列になっている、コンマで区切られた一個の文字列など）
    // になっている可能性があるので、その準備をする。
    
    
    
    
    
}


struct MathColor : Decodable, Hashable {
    
    var red : Int
    var green : Int
    var blue : Int
    var opacity : Int
    // 色相は、様々なフォーマット（分かれている、配列になっている、コンマで区切られた一個の文字列など）
    // になっている可能性があるので、その準備をする。
    
    
    
    

    
}


struct MathPageTextElm : Decodable, Hashable {
    
    var font : String
    var content : String
    var size : CGFloat
    var position : MathPosition
    var color : MathColor
    var bgColor : MathColor
    var timeIn : Int
    var timeOut : Int
    
}


struct MathPageGrpElm : Decodable, Hashable {
    
    var url : String
    var position : MathPosition
    var timeIn : Int
    var timeOut : Int
    
}


// Pages 構造体
//
struct MathPage : Decodable, Hashable {
    
    var pageNum : Int
    var duration : Int
    var textElems : [MathPageTextElm]
    var graphicElems : [MathPageGrpElm]
    
    
}


// MathSubject構造体
//
struct MathSubject : Decodable {
    
    
    var title : String
    var pages : [MathPage]
    var color : MathColor
       
    
}


struct MathSubjectResponse : Decodable {
    
    var subjects : [MathSubject]
    
    
   
    
}






// ================================================================================
//      ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//      ┃              FOR TEST              ┃
//      ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

//let json = """
//{
//    "subjects": [
//        {
//            "title" : "これはタイトル1です。",
//            "color" : {
//                                     "red": 255,
//                                     "green": 228,
//                                     "blue": 180,
//                                     "opacity": 255
//                                 },
//            "pages" :   [
//                            {
//                                "pageNum" : 1,
//                                "duration" : 5000,
//                                "textElems" : [
//
//                                    {
//                                        "font" : "GenEiKoburiMin6-R",
//                                        "content" : "コンテンツ 1-1 です。漢字のテストです。",
//                                        "size" : 50,
//                                        "position" : {
//                                                        "x" : 0.02,
//                                                        "y" : 0.2
//                                                     },
//                                        "color" : {
//                                                        "red": 255,
//                                                        "green" : 0,
//                                                        "blue" : 0,
//                                                        "opacity": 255
//                                                  },
//                                        "bgColor" : {
//                                            "red": 255,
//                                            "green" : 0,
//                                            "blue" : 0,
//                                            "opacity": 80
//                                                    },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    },
//
//                                    {
//                                        "font" : "GenEiKoburiMin6-R",
//                                        "content" : "コンテンツ 1-2 です。漢字のテストです。",
//                                        "size" : 50,
//                                        "position" : {
//                                                        "x" : 0.02,
//                                                        "y" : 0.5
//                                                     },
//                                        "color" : {
//                                                        "red": 0,
//                                                        "green" : 0,
//                                                        "blue" : 0,
//                                                        "opacity": 255
//                                                  },
//                                        "bgColor" : {
//                                            "red": 255,
//                                            "green" : 0,
//                                            "blue" : 0,
//                                            "opacity": 80
//                                                    },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    },
//
//
//                                ],
//                                "graphicElems" : [
//
//                                    {
//
//                                         "url" : "URL OF GRAPHIC 1",
//                                         "position" : {
//                                                         "x" : 0.5,
//                                                         "y" : 0.8
//                                                      },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    }
//                                ]
//                            },
//                            {
//                                "pageNum" : 2,
//                                "duration" : 5000,
//                                "textElems" : [
//
//                                    {
//                                        "font" : "GenEiKoburiMin6-R",
//                                        "content" : "コンテンツ 2-1 です。漢字のテストです。",
//                                        "size" : 50,
//                                        "position" : {
//                                                        "x" : 0.02,
//                                                        "y" : 0.2
//                                                     },
//                                        "color" : {
//                                                        "red": 0,
//                                                        "green" : 0,
//                                                        "blue" : 0,
//                                                        "opacity": 255
//                                                  },
//                                        "bgColor" : {
//                                            "red": 255,
//                                            "green" : 0,
//                                            "blue" : 0,
//                                            "opacity": 80
//                                                    },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    },
//
//                                    {
//                                        "font" : "GenEiKoburiMin6-R",
//                                        "content" : "コンテンツ 2-2 です。漢字のテストです。",
//                                        "size" : 50,
//                                        "position" : {
//                                                        "x" : 0.02,
//                                                        "y" : 0.5
//                                                     },
//                                        "color" : {
//                                                        "red": 0,
//                                                        "green" : 0,
//                                                        "blue" : 0,
//                                                        "opacity": 255
//                                                  },
//                                        "bgColor" : {
//                                            "red": 255,
//                                            "green" : 0,
//                                            "blue" : 0,
//                                            "opacity": 80
//                                                    },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    },
//
//                                    {
//                                        "font" : "AsciiMath",
//                                        "content" : "ASSSSSSSSS",
//                                        "size" : 50,
//                                        "position" : {
//                                                        "x" : 0.02,
//                                                        "y" : 0.5
//                                                     },
//                                        "color" : {
//                                                        "red": 0,
//                                                        "green" : 0,
//                                                        "blue" : 0,
//                                                        "opacity": 255
//                                                  },
//                                        "bgColor" : {
//                                            "red": 255,
//                                            "green" : 0,
//                                            "blue" : 0,
//                                            "opacity": 80
//                                                    },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    },
//
//                                ],
//                                "graphicElems" : [
//
//                                    {
//
//                                         "url" : "URL OF GRAPHIC 2",
//                                         "position" : {
//                                                         "x" : 0.5,
//                                                         "y" : 0.8
//                                                      },
//                                        "timeIn" : 0,
//                                        "timeOut" : 1000
//                                    }
//                                ]
//                            }
//
//
//                        ]
//         }
//
//
//    ]
//
//
//}
//
//
//""".data(using: .utf8)!




//let mathSubjectsRes = try! JSONDecoder().decode(MathSubjectResponse.self, from: json)
//
//
//print(mathSubjectsRes.subjects[0].title)
//print(mathSubjectsRes.subjects[0].pages[0].pageNum)
//print(mathSubjectsRes.subjects[0].pages[0].textElems[0].content)
//print(mathSubjectsRes.subjects[0].pages[0].textElems[0].position)
//print(mathSubjectsRes.subjects[0].pages[0].textElems[0].timeIn)
//print(mathSubjectsRes.subjects[0].pages[0].textElems[0].timeOut)
//
//print(mathSubjectsRes.subjects[0].pages[0].graphicElems[0].url)
//print(mathSubjectsRes.subjects[0].pages[0].graphicElems[0].position)
//print(mathSubjectsRes.subjects[0].pages[0].graphicElems[0].timeIn)
//print(mathSubjectsRes.subjects[0].pages[0].graphicElems[0].timeOut)





