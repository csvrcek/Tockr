//
//  WelcomeViewController.swift
//  Tockr
//
//  Created by Connor Svrcek on 8/20/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    let pickerValues: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, howManyLabel, pomodoroDesc, valuesPickerView, selectButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20.0
        return stack
    }()
    
    let welcomeLabel: UILabel = {
        let welcome = UILabel()
        welcome.text = "Good"
        welcome.font = UIFont(name: "Helvetica-Bold", size: 32)
        welcome.textColor = UIColor.white
        return welcome
    }()
    
    let howManyLabel: UILabel = {
        let howMany = UILabel()
        howMany.text = "How many pomodoros would you like to complete?"
        howMany.numberOfLines = 5
        howMany.font = UIFont(name: "Helvetica-Bold", size: 32)
        howMany.textColor = UIColor.white
        return howMany
    }()
    
    let pomodoroDesc: UILabel = {
        let desc = UILabel()
        desc.text = "One pomodoro is 25 minutes long."
        desc.font = UIFont(name: "Helvetica", size: 18)
        desc.textColor = UIColor.white
        return desc
    }()
    
    let valuesPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let selectButton: UIButton = {
        let select = UIButton(type: .system)
        select.setTitle("Let's go!", for: .normal)
        select.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 24)
        select.setTitleColor(UIColor.white, for: .normal)
        select.layer.borderColor = UIColor.white.cgColor
        select.layer.cornerRadius = 10.0
        select.layer.borderWidth = 1.0
        select.addTarget(self, action: #selector(letsGoOnClick), for: .touchUpInside)
        return select
    }()
    
    let pomodoroTransition: CATransition = {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }()
    
    @objc func letsGoOnClick() {
        navigationController?.pushViewController(PomodoroViewController(numPomodoros: pickerValues[valuesPickerView.selectedRow(inComponent: 0)]), animated: true)
    }

    // Setup the label stack constraints
    func setupLabelStack() {
        // Set the selectButton constraints
        selectButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        labelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        labelStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
    }
    
    // Set labels and background image based on time of day
    func findTimeOfDay() {
        let hour = Calendar.current.component(.hour, from: Date())
        var timeOfDay = ""
        
        switch hour {
        case let h where h < 12:
            timeOfDay = "morning"
        case 12..<18:
            timeOfDay = "afternoon"
            welcomeLabel.textColor = UIColor.black
            howManyLabel.textColor = UIColor.black
            pomodoroDesc.textColor = UIColor.black
        case 18..<21:
            timeOfDay = "evening"
        default:
            timeOfDay = "night"
        }
        
        setBackgroundImage(called: timeOfDay)
        welcomeLabel.text?.append(" " + timeOfDay + ".")
    }
    
    // Set the background image based on time of day
    func setBackgroundImage(called name: String) {
        let background = UIImage(named: name)
        
        let backgroundView = UIImageView(frame: view.bounds)
        backgroundView.image = background
        backgroundView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundView.clipsToBounds = true
        backgroundView.center = view.center
        
        view.addSubview(backgroundView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Welcome"
        findTimeOfDay()
        
        valuesPickerView.dataSource = self
        valuesPickerView.delegate = self
        
        view.addSubview(labelStack)
        setupLabelStack()
        
        //view.window?.layer.add(pomodoroTransition, forKey: kCATransition)
    }
    
    // Hide the navbar in this controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Make the navbar appear in other controllers
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

extension WelcomeViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension WelcomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerValues[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: String(pickerValues[row]), attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica-Bold", size: 32)!, NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
}


