//
//  RecordSoundController.swift
//  Pitch Perfect
//
//  Created by jorjun on 10/03/2015.
//  Copyright (c) 2015 jorjun technical services. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var stop_recording_button: UIButton!
    @IBOutlet weak var record_button: UIButton!
    @IBOutlet weak var recording_in_progress: UILabel!
    var recorded_audio: RecordedAudio!
    var av_recorder: AVAudioRecorder!

    
    @IBAction func do_audio_record(sender: UIButton) {
        recording_in_progress.hidden = false
        stop_recording_button.hidden = false

        let dir_path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var current_time = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyy-HHmmss"
        var recording_name = formatter.stringFromDate(current_time) + ".wav"
        var path_array = [dir_path, recording_name]
        let file_path = NSURL.fileURLWithPathComponents(path_array)
        println(file_path)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        av_recorder = AVAudioRecorder(URL: file_path, settings: nil, error: nil)
        av_recorder.meteringEnabled = true
        av_recorder.prepareToRecord()
        av_recorder.record()
        av_recorder.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stop_recording" {
            println("prepareForSegue")
            let vc_play_sound = segue.destinationViewController as PlaySoundsController
            let data = sender as RecordedAudio
            vc_play_sound.received_audio = data
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recorded_audio = RecordedAudio()
            recorded_audio.file_path_url = recorder.url  // file path
            recorded_audio.title = recorder.url.lastPathComponent // file base name
            println("Stopped recording")
            self.performSegueWithIdentifier("stop_recording", sender: recorded_audio)
            
        } else {
            println("Recording did not finish successfully")
            record_button.enabled = true
        }
    }

    @IBAction func stop_record(sender: UIButton) {
        recording_in_progress.hidden = true
        stop_recording_button.hidden = true
        av_recorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)  // Release audio session lock
        println("!stop_record")
    }
    
    override func viewWillAppear(animated: Bool) {
        stop_recording_button.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

