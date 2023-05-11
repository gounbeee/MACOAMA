//  Swift Synth
//
//  Created by Grant Emerson on 7/21/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.

// **** FORKED FROM ABOVE CODE ****

//
//  SynthController.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/11.
//



import SwiftUI




class SynthController: ObservableObject {
    
    
    var synthModel : SynthModel = SynthModel(frequency: 0.0, amplitude: 0.0, waveType: 0)
    

    @Published var frequency : Double = 0.0
    @Published var amplitude : Double = 0.0
    @Published var waveType : Double = 0.0

    
    // @objc 属性指定でObj-Cとしても実行するようにコンパイルする
    //
    //
    //
    @objc func updateOscillatorWaveform() {
        
        let waveform = Waveform(rawValue: Int(self.waveType))!
        
        switch waveform {
            
            case .sine:       Synth.shared.setWaveformTo(Oscillator.sine)
            case .triangle:   Synth.shared.setWaveformTo(Oscillator.triangle)
            case .sawtooth:   Synth.shared.setWaveformTo(Oscillator.sawtooth)
            case .square:     Synth.shared.setWaveformTo(Oscillator.square)
            case .whiteNoise: Synth.shared.setWaveformTo(Oscillator.whiteNoise)
            
        }
        
    }
    
    
    
    @objc func setPlaybackStateTo(_ state: Bool) {
        
        Synth.shared.volume = state ? 0.5 : 0
        if !state { Synth.shared.frequency = 0 }
        
    }
    
    
    func updateState() {
        updateOscillatorWaveform()
        Oscillator.amplitude = Float(self.amplitude + Double.random(in: 0.05...0.1))
        Synth.shared.frequency = Float(self.frequency + Double.random(in: 0.0...500.0))
        
    }
    
    
    
    
    
    
    func setSynthParametersFrom() {
        
        Oscillator.amplitude = Float(self.amplitude)
        //Synth.shared.frequency = Float(100 / 100) * 1014 + 32
        Synth.shared.frequency = Float(self.frequency)
        
        
        //let amplitudePercent = Int(Oscillator.amplitude * 100)
        //let frequencyHertz = Int(Synth.shared.frequency)
        
        //parameterLabel.text = "Frequency: \(frequencyHertz) Hz  Amplitude: \(amplitudePercent)%"
        
        
    }
    


    
}
