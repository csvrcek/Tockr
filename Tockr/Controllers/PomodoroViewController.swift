//
//  PomodoroViewController.swift
//  Tockr
//
//  Created by Connor Svrcek on 8/20/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import UICircularProgressRing

class PomodoroViewController: UIViewController {
    // Declare timer variables
    var timer = Timer()
    var seconds = 1500
    var isTimerRunning = false
    var resumeTapped = false
    
    // Progress ring for tracking completed pomodoros
    lazy var progRing: UICircularProgressRingView = {
        let ring = UICircularProgressRingView(frame: CGRect(x: 50, y: 100, width: 75, height: 75))
        ring.maxValue = 4
        ring.ringStyle = .gradient
        ring.innerRingWidth = 5.0
        ring.outerRingWidth = 4.0
        ring.valueIndicator = "/4"
        ring.gradientColors = [UIColor(hexString: "#0575E6"), UIColor(hexString: "#00F260")]
        return ring
    }()
    
    // Set up the timer
    lazy var timerLabel: UILabel = {
        let timerLabel = UILabel(frame: view.frame)
        timerLabel.text = "25:00"
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont(name: "HelveticaNeue-Ultralight", size: 100)
        return timerLabel
    }()
    
    // Set up start button
    let start: UIButton = {
        let start = UIButton()
        //start.layer.cornerRadius = 0.5 * start.bounds.size.width
        start.setTitle("Start", for: .normal)
        start.setTitleColor(UIColor.black, for: .normal)
        start.setTitleColor(UIColor.gray, for: .disabled)
        start.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 35)
        start.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return start
    }()
    
    // Set up the pause button
    let pause: UIButton = {
        let pause = UIButton()
        pause.setTitle("Pause", for: .normal)
        pause.setTitleColor(UIColor.black, for: .normal)
        pause.setTitleColor(UIColor.gray, for: .disabled)
        pause.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 35)
        pause.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        return pause
    }()
    
    // Set up the reset button
    let reset: UIButton = {
        let reset = UIButton()
        reset.setTitle("Reset", for: .normal)
        reset.setTitleColor(UIColor.black, for: .normal)
        reset.setTitleColor(UIColor.gray, for: .disabled)
        reset.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 35)
        reset.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        return reset
    }()
    
    // Stackview for buttons
    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [start, pause, reset])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Set up button stack view constraints
    func setupButtonStackView() {
        buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
    }
    
    // Set up constraints for timerLabel
    func setupTimerConstraints() {
        timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // Displaying timer
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // When start button is pressed
    @objc func startButtonTapped() {
        if !isTimerRunning {
            runTimer()
            start.isEnabled = false
        }
    }
    
    // Running timer
    @objc func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pause.isEnabled = true
        reset.isEnabled = true
    }
    
    // Updating each second on the timer
    @objc func updateTimer() {
        if seconds < 1 {
            // TODO: send alert to show time's up
            if progRing.currentValue! < CGFloat(integerLiteral: 4) {
                progRing.setProgress(value: progRing.currentValue! + 1, animationDuration: 1.0)
            }
            timer.invalidate()
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    // When pause is pressed
    @objc func pauseTimer() {
        if !self.resumeTapped {
            timer.invalidate()
            self.resumeTapped = true
            self.pause.setTitle("Resume", for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pause.setTitle("Pause", for: .normal)
        }
    }
    
    // When reset is pressed
    @objc func resetTimer() {
        timer.invalidate()
        
        timerLabel.text = "25:00"
        seconds = 15002
        isTimerRunning = false
        pause.isEnabled = false
        reset.isEnabled = false
        start.isEnabled = true
        resumeTapped = false
        pause.setTitle("Pause", for: .normal)
    }
    
    // Set up navigation controller
    func setupNav() {
        navigationItem.title = "Tockr"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(progRing)
        
        view.addSubview(timerLabel)
        setupTimerConstraints()
        
        view.addSubview(buttonStackView)
        setupButtonStackView()
        
        // Disable pause button
        self.pause.isEnabled = false
        self.reset.isEnabled = false
        
        setupNav()
        //navigationController?.present(WelcomeViewController(), animated: true, completion: nil)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

// Disable auto rotation
extension UINavigationController {
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}







