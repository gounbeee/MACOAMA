//
//  MusicPlayView.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/13.
//

import SwiftUI
import AVKit


struct MusicPlayView: View {
    
    @State var audioPlayer: AVAudioPlayer!
   
    
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
    
    
    init(synthCtr: SynthController) {
        
        self.synthCtr = synthCtr
        
    }
    
    
    
    var body: some View {
                
        VStack {
            
            HStack {

                Button(action: {
                    self.audioPlayer.play()
                    
                }) {
                    
                    Image(systemName: "play.circle.fill")
                        
                }
                                

                Button(action: {
                    
                    self.audioPlayer.pause()
                    
                }) {
                    
                    Image(systemName: "pause.circle.fill")
                        
                }

                
            }
            
            VStack {
                
//                MusicProgressSlider(value: $playerDuration,
//                                    inRange: TimeInterval.zero...maxDuration,
//                                    activeFillColor: color,
//                                    fillColor: normalFillColor,
//                                    emptyColor: emptyColor,
//                                    height: 8) { started in
//
//                }
//                .frame(height: 20)
                
                
                MusicVolumeSlider(value: $volume,
                                  inRange: 0...maxVolume,
                                  activeFillColor: color,
                                  fillColor: normalFillColor,
                                  emptyColor: emptyColor,
                                  height: 8) { started in
                    
                    
                    print(started)
                    print(self.volume)
                    
                    self.audioPlayer.volume = Float(self.volume)
                    self.synthCtr.amplitude = self.volume
                    
                }
                .frame(height: 20)
            }
            
            
            
            
        }
        .onAppear {
            
            let sound = Bundle.main.path(forResource: "01", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            
        }
        
        
        
    }
    
    
    
}
