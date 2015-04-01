//
//  PlaySoundController.swift
//  Pitch Perfect
//
//  Created by jorjun on 17/03/2015.
//  Copyright (c) 2015 jorjun technical services. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsController: UIViewController {

    var av_player : AVAudioPlayer!
    var received_audio: RecordedAudio!
    var audio_engine: AVAudioEngine!
    var audio_file: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audio_engine = AVAudioEngine()
        audio_file = AVAudioFile(forReading: received_audio.file_path_url, error: nil)
        av_player = AVAudioPlayer(contentsOfURL: received_audio.file_path_url, error: nil)
        av_player.enableRate = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func play_audio(rate: Float) {
        av_player.stop()
        av_player.currentTime = 0
        av_player.rate = rate
        av_player.play()
        
    }
    
    @IBAction func PlaySlowButton(sender: AnyObject) {
        self.play_audio(0.5)
    }
    
    @IBAction func playFastButton(sender: UIButton) {
        self.play_audio(2)
    }
    
    @IBAction func stopButton(sender: UIButton) {
        av_player.stop()
    }

    func play_audio_varying_pitch(pitch: Float) {
        audio_engine.stop()
        audio_engine.reset()

        var pitch_player = AVAudioPlayerNode()  // Main player node
        var time_pitch_effect = AVAudioUnitTimePitch()
        time_pitch_effect.pitch = pitch

        // The nodes attached
        audio_engine.attachNode(pitch_player)
        audio_engine.attachNode(time_pitch_effect)
        
        // The nodes connected pipeline order
        audio_engine.connect(pitch_player, to: time_pitch_effect, format: audio_file.processingFormat)
        audio_engine.connect(time_pitch_effect, to: audio_engine.outputNode, format: audio_file.processingFormat)
        
        pitch_player.scheduleFile(audio_file, atTime: nil, completionHandler: nil)
        audio_engine.startAndReturnError(nil)
        
        pitch_player.play()
    }

    @IBAction func playDarthAudio(sender: UIButton) {
        self.play_audio_varying_pitch(-1000)
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        self.play_audio_varying_pitch(1000)
    }
    
}
