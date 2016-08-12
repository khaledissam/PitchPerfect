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
// 13. Stack view for different device size


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

    @IBAction func recordAudio() {
        setUIState(true, recordingText: "Recording in progress")
        
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
        setUIState(false, recordingText: "Tap to Record")
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    private func setUIState(isRecording : Bool, recordingText: String) {
        recordingLabel.text = recordingText
        recordButton.enabled = !isRecording
        stopRecordButton.enabled = isRecording
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegueWithIdentifier("record to play", sender: audioRecorder.url)
        } else {
            displayAlert("Error", messageText: "Failed to record")
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
    
    func displayAlert(messageTitle: String, messageText: String) {
        let alert = UIAlertController(title: messageTitle, message:messageText, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

