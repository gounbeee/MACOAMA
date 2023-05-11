//
//  SynthVM.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/11.
//

import SwiftUI

struct SynthVM: View {
    

    @ObservedObject var synthCtr : SynthController
    

    
    var body: some View {
        
        
        Text("Frequency: \(String(self.synthCtr.frequency)) Hz  Amplitude: \(String(self.synthCtr.amplitude)) %")
        
        
        Slider(value: self.$synthCtr.waveType,
               in: 0...4,
               step: 1,
               onEditingChanged: { _ in

            self.synthCtr.updateOscillatorWaveform()
            self.synthCtr.updateState()

        })
        
        
        Slider(value: self.$synthCtr.amplitude,
               in: 0...1,
               step: 0.01,
               onEditingChanged: { _ in
            print(self.synthCtr.amplitude)
            
            self.synthCtr.updateOscillatorWaveform()
            self.synthCtr.updateState()
            
        })
        
        
        Slider(value: self.$synthCtr.frequency,
               in: 1...2000,
               step: 1,
               onEditingChanged: { _ in
            print(self.synthCtr.frequency)
            
            self.synthCtr.updateOscillatorWaveform()
            self.synthCtr.updateState()
            
        })
        
        
           
        HStack {
            
            
            Button("STOP SOUND") {
                
                self.synthCtr.setPlaybackStateTo(false)
               
            }
            
            
            
            Button("PLAY SINE SOUND") {
                
                self.synthCtr.waveType = 0
                self.synthCtr.updateOscillatorWaveform()
                self.synthCtr.updateState()
                self.synthCtr.setPlaybackStateTo(true)
                
            }
            
            
            Button("PLAY TRIANGLE SOUND") {
                
                self.synthCtr.waveType = 1
                self.synthCtr.updateOscillatorWaveform()
                self.synthCtr.updateState()
                self.synthCtr.setPlaybackStateTo(true)
                
            }

            
            Button("PLAY SAWTOOTH SOUND") {
                
                self.synthCtr.waveType = 2
                self.synthCtr.updateOscillatorWaveform()
                self.synthCtr.updateState()
                self.synthCtr.setPlaybackStateTo(true)
                
            }
            
            
            Button("PLAY SQUARE SOUND") {
                
                self.synthCtr.waveType = 3
                self.synthCtr.updateOscillatorWaveform()
                self.synthCtr.updateState()
                self.synthCtr.setPlaybackStateTo(true)
                
            }
            
            
            Button("PLAY WHITENOISE SOUND") {
                
                self.synthCtr.waveType = 4
                self.synthCtr.updateOscillatorWaveform()
                self.synthCtr.updateState()
                self.synthCtr.setPlaybackStateTo(true)
                
            }
            
            

            
            
        }
        
        
    }
    
    
    
    
    
}



