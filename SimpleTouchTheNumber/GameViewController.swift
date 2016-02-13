//
//  GameViewController.swift
//  SimpleTouchTheNumber
//
//  Created by 井上圭一 on 2016/02/06.
//  Copyright © 2016年 keiichi, inoue. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var readyScreenView: UIView!
    @IBOutlet weak var readyCountLabel: UILabel!
    
    @IBOutlet weak var clearImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var timerCountLabel: UILabel!
    
    @IBOutlet var numButton: [UIButton]!
    
    var timerCountDown: NSTimer!
    var numberCountDown = 3;
    
    var timerCountUp: NSTimer!
    var numberCountUp = 0.0;
    
    var positionArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var indexNum = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerCountDown = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
    }
    
    func countDown() {
        if numberCountDown <= 1 {
            timerCountDown.invalidate()
            
            start()
        } else {
            numberCountDown -= 1
            readyCountLabel.text = String(numberCountDown)
        }
    }
    
    func start() {
        readyCountLabel.hidden = true
        readyScreenView.hidden = true
        
        shuffleArray()
        
        let buttonColor = selectButtonColor()
        
        setButtonImage(positionArray, color: buttonColor)
        
        indexNum = 1
        
        timerCountUp = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("countUp"), userInfo: nil, repeats: true)
    }
    
    func shuffleArray() {
        for var j = positionArray.count - 1; j > 0; j-- {
            let k = Int(arc4random_uniform(UInt32(j))) // 0 <= k < j
            swap(&positionArray[k], &positionArray[j])
        }
    }
    
    func setButtonImage(positionArray: [Int], color: String) {
        for i in 0..<9 {
            let img:UIImage = UIImage(named: (color+String(positionArray[i])+".png"))!
            numButton[i].setImage(img, forState: UIControlState.Normal)
            numButton[i].hidden = false;
        }
    }
    
    func selectButtonColor() -> String {
        let array = ["b", "g", "r"]
        let num = Int(arc4random_uniform(UInt32(array.count)))
        return array[num]
    }
    
    func countUp() {
        timerCountLabel.text = "Time: ".stringByAppendingFormat("%.2f", numberCountUp)
        numberCountUp += 0.01
    }
    
    @IBAction func numButtonAction(sender: UIButton) {
        
        if positionArray[sender.tag-1] == indexNum {
            
            UIView.animateWithDuration(1.0, animations: {
                sender.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                sender.transform = CGAffineTransformMakeScale(0.001, 0.001)
                sender.alpha = 0.0
                }, completion: { (finish: Bool) -> Void in
                    sender.hidden = true;
                    
                    sender.transform = CGAffineTransformMakeRotation(0)
                    sender.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    sender.alpha = 1.0
                }
            )
            
            indexNum++;
            if indexNum >= 10 {
                clear()
            }
        }
    }
    
    func clear() {
        timerCountUp.invalidate()
        numberCountUp = 0.0
        
        clearImage.hidden = false;
        startButton.hidden = false;
        topButton.hidden = false;
    }
    
    @IBAction func startButtonAction(sender: UIButton) {
        clearImage.hidden = true;
        startButton.hidden = true;
        topButton.hidden = true;
        
        readyScreenView.hidden = false
        numberCountDown = 3
        readyCountLabel.text = String(numberCountDown)
        readyCountLabel.hidden = false
        
        timerCountDown = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
    }
    
    @IBAction func topButtonAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}