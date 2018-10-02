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
    init(numPomodoros: Int) {
        self.numPomodoros = numPomodoros
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Declare timer variables
    var timer = Timer()
    var seconds = 1500
    var isTimerRunning = false
    var resumeTapped = false
    
    var numPomodoros: Int
    
    // Stackview for both progress ring stackviews
    lazy var progRingParentStackView: UIStackView = {
        let parentStack = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        parentStack.axis = .vertical
        parentStack.backgroundColor = UIColor.blue
        parentStack.translatesAutoresizingMaskIntoConstraints = false
        return parentStack
    }()
    
    // Top prog ring stackview
    lazy var topStackView: UIStackView = {
        let top = UIStackView(arrangedSubviews: [progRing, timerLabel, progRing])
        print("the size of the top arrangedSubviews is \(top.arrangedSubviews.count)")
        top.axis = .horizontal
        top.distribution = .equalSpacing
        top.translatesAutoresizingMaskIntoConstraints = false
        return top
    }()
    
    // Bottom prog ring stackview
    lazy var bottomStackView: UIStackView = {
        let bottom = UIStackView(arrangedSubviews: [progRing, progRing, progRing])
        bottom.axis = .horizontal
        bottom.distribution = .equalSpacing
        bottom.translatesAutoresizingMaskIntoConstraints = false
        return bottom
    }()
    
    // Stackview for buttons
    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [start, pause, reset])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Progress ring for tracking completed pomodoros
    let progRing: UICircularProgressRingView = {
        let ring = UICircularProgressRingView()
        ring.isHidden = true
        ring.maxValue = 4
        ring.ringStyle = .gradient
        ring.innerRingWidth = 5.0
        ring.outerRingWidth = 4.0
        ring.valueIndicator = "/4"
        ring.fontColor = UIColor.white
        ring.gradientColors = [UIColor(hexString: "#0575E6"), UIColor(hexString: "#00F260")]
        return ring
    }()
    
    // Set up the timer
    lazy var timerLabel: UILabel = {
        let timerLabel = UILabel(frame: view.frame)
        timerLabel.text = "25:00"
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont(name: "Helvetica-Bold", size: 100)
        timerLabel.textColor = UIColor.white
        return timerLabel
    }()
    
    // Set up start button
    let start: UIButton = {
        let start = UIButton()
        //start.layer.cornerRadius = 0.5 * start.bounds.size.width
        start.setTitle("Start", for: .normal)
        start.setTitleColor(UIColor.white, for: .normal)
        start.setTitleColor(UIColor.gray, for: .disabled)
        start.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 32)
        start.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return start
    }()
    
    // Set up the pause button
    let pause: UIButton = {
        let pause = UIButton()
        pause.setTitle("Pause", for: .normal)
        pause.setTitleColor(UIColor.white, for: .normal)
        pause.setTitleColor(UIColor.gray, for: .disabled)
        pause.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 32)
        pause.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        return pause
    }()
    
    // Set up the reset button
    let reset: UIButton = {
        let reset = UIButton()
        reset.setTitle("Reset", for: .normal)
        reset.setTitleColor(UIColor.white, for: .normal)
        reset.setTitleColor(UIColor.gray, for: .disabled)
        reset.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 32)
        reset.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        return reset
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
    
    // Constrain the stack views for the prog rings
    func setupProgRingStackViews() {
        // Parent stack view
        progRingParentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progRingParentStackView.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor, constant: -150).isActive = true
        progRingParentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        progRingParentStackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Top stack view
        topStackView.topAnchor.constraint(equalTo: progRingParentStackView.topAnchor).isActive = true
        topStackView.heightAnchor.constraint(equalTo: progRingParentStackView.heightAnchor, multiplier: 1/2).isActive = true
        topStackView.widthAnchor.constraint(equalTo: progRingParentStackView.widthAnchor).isActive = true
        
        // Bottom stack view
        bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
        bottomStackView.heightAnchor.constraint(equalTo: progRingParentStackView.heightAnchor, multiplier: 1/2).isActive = true
        bottomStackView.widthAnchor.constraint(equalTo: progRingParentStackView.widthAnchor).isActive = true
    }
    
    // Constrain progRing
    func setupProgRing() {
        progRing.heightAnchor.constraint(equalToConstant: 75).isActive = true
        progRing.widthAnchor.constraint(equalToConstant: 75).isActive = true
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
        seconds = 1500
        isTimerRunning = false
        pause.isEnabled = false
        reset.isEnabled = false
        start.isEnabled = true
        resumeTapped = false
        pause.setTitle("Pause", for: .normal)
    }
    
    // Set up navigation controller
    func setupNav() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // Display the right number of prog rings depending on the number of pomodoros
    func renderProgRings() {
//        for _ in 0..<3 {
//            topStackView.addArrangedSubview(progRing)
//            bottomStackView.addArrangedSubview(progRing)
//        }
        
        print(topStackView.arrangedSubviews.count)
        
        for pom in 0..<numPomodoros {
            //topStackView.addArrangedSubview(progRing)
            //bottomStackView.addArrangedSubview(progRing)

            topStackView.arrangedSubviews[pom].isHidden = false
            bottomStackView.arrangedSubviews[pom].isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#FF6347")
        
        view.addSubview(timerLabel)
        setupTimerConstraints()
        
        view.addSubview(buttonStackView)
        setupButtonStackView()
        
        view.addSubview(progRingParentStackView)
        setupProgRingStackViews()
        setupProgRing()
        renderProgRings()
        
        // Disable pause and reset buttons
        self.pause.isEnabled = false
        self.reset.isEnabled = false
        
        setupNav()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}
