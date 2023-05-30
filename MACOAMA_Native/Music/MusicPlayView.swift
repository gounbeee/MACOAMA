//
//  MusicPlayView.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/13.
//

import SwiftUI
import AVKit
import Combine

struct MusicPlayView: View {
    
    @State var audioPlayer: AVAudioPlayer? = nil
   
    
    @State private var playerDuration: TimeInterval = 100
    private let maxDuration = TimeInterval(240)
    
    @State private var volume: Double = 0.3
    private var maxVolume: Double = 1
    
    @State private var sliderValue: Double = 10
    private var maxSliderValue: Double = 100
    
    @State private var color: Color = .accentColor
    
    private var normalFillColor: Color { color.opacity(0.5) }
    private var emptyColor: Color { color.opacity(0.3) }
    
    @ObservedObject var synthCtr : SynthController
    
    @ObservedObject var ctr : MathSubjectController
    
    @ObservedObject var bleCtr : BluetoothController

    
    @State var pageNum : String = "1"

    @State var isPlaying : Bool = false
    
    
    // TIMER を使う
    // https://sarunw.com/posts/timer-in-swiftui/
    @State var startDate = Date.now
    @State var timeElapsed: Double = 0
    
    var timer : Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 0.033, on: .main, in: .common).autoconnect()
    
    
    
    // 音楽ファイルのリスト
    var mp3FilePath : String? = nil
    
    
    
    
    init(synthCtr: SynthController, ctr: MathSubjectController, bleCtr: BluetoothController) {
        
        //print("MusicPlayView が生成された")
        
        self.synthCtr = synthCtr
        self.ctr = ctr
        self.bleCtr = bleCtr
        self.pageNum = String(self.ctr.pageNo+1)
        
        getMusicFile()
        
        //print(self.audioPlayer)
    }
    
    
    
    func playMusic() {
        
        // 音楽ファイルのパスをもう一度チェック
        if let filePath = self.mp3FilePath {
            
            print(filePath)
            
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            
            //print(self.audioPlayer)
            
            self.synthCtr.audioPlayer = self.audioPlayer
            
            
            
            if let testedAudioPlayer = self.audioPlayer {
                
                // 既に音楽を再生中なら停止させる
                if self.isPlaying == true {
                    self.stopMusic()
                }
                
                // 音楽を再生
                testedAudioPlayer.play()
             
                self.ctr.pageNo = 0
                self.pageNum = String(self.ctr.pageNo+1)
                
                self.ctr.reloadPage()

                // 現在の時間にスタート時刻を更新
                self.startDate = Date.now

                self.isPlaying = true
                
            }
        }
    }
    
    

    func stopMusic() {
        
        if let testedAudioPlayer = self.audioPlayer {
    
            // 音楽を停止
            testedAudioPlayer.stop()
            testedAudioPlayer.currentTime = 0.0
            
            self.timer.upstream.connect().cancel()
            
            self.audioPlayer = nil
            
            self.isPlaying = false
            

        }
    }
        
      
    
    var body: some View {
           
        // 音楽関連UIは、現在のサブジェクトに音楽ファイルが見つからなかったらそもそも表示させない！
        if self.mp3FilePath != nil {
            
            VStack {
                
                // もしこのViewが描画されたとき、音楽がなっている時のみ、秒数カウントを行う
                if self.isPlaying == true && self.audioPlayer != nil {
                    
                    Text("時間: \(Int(self.timeElapsed)) 秒")
                        .onReceive(self.timer) { firedDate in
                            
                            self.timeElapsed = firedDate.timeIntervalSince(self.startDate)
                            
                            // print("時間経過 self.timeElapsed  -->  \(self.timeElapsed)")
                            
                            // SLIDE を移動させる
                            // print(self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].duration)
                            let duration = Double(self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].duration)
                            let elapsedMillis = self.timeElapsed * 1000.0
                            
                            
                            if elapsedMillis > duration {
                                
                                // まだ再生できるページがあれば進む。でなければストップ
                                if self.ctr.pageNo < self.ctr.pageNumInSubject-1 {
                                    
                                    //print("LET US JUMP TO NEXT SLIDE !!")
                                    self.ctr.jumpToNextPageSafely()
                                    
                                    //  タイマーのリセット
                                    self.startDate = Date.now
                                    
                                } else {
                                    
                                    // 音楽を停止
                                    self.stopMusic()
                                    
                                }
                            }
                        }
                }
                
                
                
                // 音楽再生、停止用のボタン
                HStack {
                    
                    Button(action: {
                        // 音楽再生
                        self.playMusic()
                        
                    }) {
                        
                        Image(systemName: "play.circle.fill")
                        
                    }
                    
                    
                    Button(action: {
                        
                        if self.isPlaying == true {
                            
                            // 音楽を停止
                            self.stopMusic()
                            
                            
                            
                        }
                        
                        
                    }) {
                        
                        Image(systemName: "stop.circle.fill")
                        
                    }

                    
                }
                
                // ボリューム調整用のスライダー
                VStack {
      
                    MusicVolumeSlider(value: $volume,
                                      inRange: 0...maxVolume,
                                      activeFillColor: color,
                                      fillColor: normalFillColor,
                                      emptyColor: emptyColor,
                                      height: 8) { started in
                        
                        
                        //print(started)
                        //print(self.volume)
                        
                        if let testedAudioPlayer = self.audioPlayer {
                            
                            testedAudioPlayer.volume = Float(self.volume)
                            self.synthCtr.amplitude = self.volume
                            
                            
                        }

                    }
                    .frame(height: 20)
                }
                
            }
            
        }
        
        
        //let _ = print("MusicPlayView   ->   $pageNum  ::  \(self.pageNum)")
        
        // 音楽再生に影響されるため、ナビゲーションの一部分はこの構造体の中におく
        // self.$pageNum をトリガーにして更新する
        // **　同様に、中でサブジェクト、ページを遷移させた時、音楽再生中の表示物を初期化するため、
        //     self.$isPlaying　を送っている。
        //    中で、このフラグを動かすと、Bindingなので「この」オブジェクトが更新される。
        MathSubjectCommandView(ctr: self.ctr,
                               pageNumInSubject: self.ctr.pageNumInSubject,
                               subjectNum: String(self.ctr.subjectNo+1),
                               pageNum: self.$pageNum,
                               bluetoothCtr: self.bleCtr,
                               isSubjectVisible: true,
                               isPageVisible: true,
                               synthCtr: self.synthCtr,
                               musicIsPlaying: self.$isPlaying)
        
        
        
    }
    
    
    
    
    
    mutating func getMusicFile() {
        
        let fileNum = String(format: "%03d", self.ctr.subjectNo+1)
        
        //print(fileNum)
        
        // 正当なパスの音楽ファイルがあるかをチェック
        if let testedPath = Bundle.main.path(forResource: fileNum, ofType: "mp3") {
            
            self.mp3FilePath = testedPath
            
            //print(self.mp3FilePath)
            
        } else {
            
            //
            
            self.mp3FilePath = nil
            
        }
        
        //print(self.mp3FilePath)
    }
    

    
}
