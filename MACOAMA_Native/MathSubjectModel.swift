//
//  MathSubjects.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/22.
//

import Foundation



enum MathPageType : String, Codable {
    
    case text = "text"
    case graphic = "graphic"
    
}


struct MathPosition : Codable, Hashable {
    
    var x : Double
    var y : Double
    
    // 座標は、様々なフォーマット（分かれている、配列になっている、コンマで区切られた一個の文字列など）
    // になっている可能性があるので、その準備をする。
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    
    init(position: CGPoint) {
        self.x = position.x
        self.y = position.y
    }
    
}


struct MathColor : Codable, Hashable {

    var red : Int
    var green : Int
    var blue : Int
    var opacity : Int
    // 色相は、様々なフォーマット（分かれている、配列になっている、コンマで区切られた一個の文字列など）
    // になっている可能性があるので、その準備をする。
    
    
    
    

    
}


struct MathPageTextElm : Codable, Hashable {
    
    var id : String
    var font : String
    var content : String
    var size : CGFloat
    var position : MathPosition
    var color : MathColor
    var bgColor : MathColor
    var timeIn : Int
    var timeOut : Int
    
}


struct MathPageGrpElm : Codable, Hashable {
    
    var url : String
    var position : MathPosition
    var timeIn : Int
    var timeOut : Int
    
}


// Pages 構造体
//
struct MathPage : Codable, Hashable {
    
    var pageNum : Int
    var duration : Int
    var textElems : [MathPageTextElm]
    var graphicElems : [MathPageGrpElm]
    
    
}


// MathSubject構造体
//
struct MathSubject : Codable {
    
    
    var title : String
    var pages : [MathPage]
    var color : MathColor
       
    
}


class MathSubjectResponse : Codable {
    
    var subjects : [MathSubject]
    
    init(subjects : [MathSubject]) {
        
        self.subjects = subjects
    }
   
    
}


//
//{
//    "subjects": [
//        {
//            "title" : "これはタイトル1です。",
//            "color" : {
//                "red": 255,
//                "green": 228,
//                "blue": 180,
//                "opacity": 255
//            },
//            "pages" :   [
//                {
//                    "pageNum" : 1,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt1-1-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 1-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt1-1-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 1-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 1",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 2,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt1-2-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 2-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt1-2-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 2-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt1-2-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 2",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 3,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt1-3-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 3-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt1-3-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 3-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt1-3-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 3",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 4,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt1-4-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 4-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt1-4-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 4-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt1-4-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//                        {
//                            "url" : "URL OF GRAPHIC 4",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 5,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt1-5-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 5-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt1-5-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 5-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt1-5-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 5",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                }
//
//            ]
//        },
//        {
//            "title" : "これはタイトル2です。",
//            "color" : {
//                "red": 255,
//                "green": 228,
//                "blue": 180,
//                "opacity": 255
//            },
//            "pages" :   [
//                {
//                    "pageNum" : 1,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt2-1-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 1-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt2-1-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 1-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 1",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 2,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt2-2-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 2-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt2-2-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 2-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt2-2-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 2",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 3,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt2-3-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 3-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt2-3-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 3-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt2-3-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 3",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 4,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt2-4-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 4-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt2-4-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 4-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt2-4-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//                        {
//                            "url" : "URL OF GRAPHIC 4",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 5,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt2-5-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 5-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt2-5-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 5-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt2-5-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 5",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                }
//
//            ]
//        },
//        {
//            "title" : "これはタイトル3です。",
//            "color" : {
//                "red": 255,
//                "green": 228,
//                "blue": 180,
//                "opacity": 255
//            },
//            "pages" :   [
//                {
//                    "pageNum" : 1,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt3-1-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 1-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt3-1-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 1-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 1",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 2,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt3-2-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 2-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt3-2-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 2-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt3-2-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 2",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 3,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt3-3-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 3-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt3-3-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 3-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt3-3-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 3",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 4,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt3-4-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 4-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt3-4-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 4-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                        {
//                            "id" : "txt3-4-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//
//                    ],
//                    "graphicElems" : [
//                        {
//                            "url" : "URL OF GRAPHIC 4",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                },
//                {
//                    "pageNum" : 5,
//                    "duration" : 5000,
//                    "textElems" : [
//
//                        {
//                            "id" : "txt3-5-1",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 5-1 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.2
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt3-5-2",
//                            "font" : "GenEiKoburiMin6-R",
//                            "content" : "コンテンツ 5-2 です。漢字のテストです。",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        },
//                        {
//                            "id" : "txt3-5-3",
//                            "font" : "AsciiMath",
//                            "content" : "ASSSSSSSSS",
//                            "size" : 50,
//                            "position" : {
//                                "x" : 0.02,
//                                "y" : 0.5
//                            },
//                            "color" : {
//                                "red": 0,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 255
//                            },
//                            "bgColor" : {
//                                "red": 255,
//                                "green" : 0,
//                                "blue" : 0,
//                                "opacity": 80
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//
//                    ],
//                    "graphicElems" : [
//
//                        {
//
//                            "url" : "URL OF GRAPHIC 5",
//                            "position" : {
//                                "x" : 0.5,
//                                "y" : 0.8
//                            },
//                            "timeIn" : 0,
//                            "timeOut" : 1000
//                        }
//                    ]
//                }
//
//            ]
//        }
//
//
//    ]
//
//
//}
