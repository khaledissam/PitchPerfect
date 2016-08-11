//
//  ViewController.swift
//  PictchPerfect
//
//  Created by Minjie Zhu on 8/8/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

// Notes: 
// 1. create new assets
// 2. open documents
// 3. navigation view controller
// 4. AVAudioRecorder
// 5. Delegation (protocol)
// 6. performSegue, sender is anything to send
// 7. prepareSegue, copy sender to destination vc
// 8. Stack view
// 9. New method to connect IBOutlet and IBAction
// 10. Button tag
// 11. MARK: function
// 12. if let can use same name


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordButton.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio() {
        recordingLabel.text = "Recording in progress"
        recordButton.enabled = false
        stopRecordButton.enabled = true
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording() {
        recordingLabel.text = "Tap to Record"
        stopRecordButton.enabled = false
        recordButton.enabled = true
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //print("finish audio record")
        if flag {
            performSegueWithIdentifier("record to play", sender: audioRecorder.url)
        } else {
            print("failed to record")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "record to play" {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

