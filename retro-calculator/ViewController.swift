//
//  ViewController.swift
//  retro-calculator
//
//  Created by Anthony Whitaker on 7/13/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var buttonSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation:Operation = Operation.Empty
    var result = ""
    var wasLastButtonEquals:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do{
            try buttonSound = AVAudioPlayer(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        reset()
    }
   
    @IBAction func onClearPressed(sender: UIButton) {
        if runningNumber == "" {
            reset()
        }
        else {
            runningNumber = ""
        }
    }
    
    func reset() {
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        currentOperation = Operation.Empty
        result = ""
        outputLabel.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        if wasLastButtonEquals {
            reset()
        }
        
        playSound()
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
        wasLastButtonEquals = false

    }
    
    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onSubtractPressed(sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onEqualsPressed(sender: UIButton) {
        if leftValStr != "" {
            if runningNumber == "" {
                runningNumber = rightValStr
            }
            
            processOperation(currentOperation)
            wasLastButtonEquals = true
        }
    }
    
    func processOperation(operation : Operation) {
        playSound()
        
        if currentOperation == Operation.Empty {
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        } else {
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                switch currentOperation {
                case .Multiply:
                    result = "\(Int(leftValStr)! * Int(rightValStr)!)"
                case .Divide:
                    result = "\(Int(leftValStr)! / Int(rightValStr)!)"
                case .Add:
                    result = "\(Int(leftValStr)! + Int(rightValStr)!)"
                case .Subtract:
                    result = "\(Int(leftValStr)! - Int(rightValStr)!)"
                default:
                    break
                }
                
                leftValStr = result
                outputLabel.text = result
            }
            
            currentOperation = operation
        }
        
        wasLastButtonEquals = false
    }
    
    func playSound() {
        if buttonSound.playing {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
}

