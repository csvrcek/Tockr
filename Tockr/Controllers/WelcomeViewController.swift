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
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, howManyLabel, valuesPickerView])
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
    
    lazy var valuesPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    // Setup the label stack constraints
    func setupLabelStack() {
        labelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        labelStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
    }
    
//    // Setup the picker view constraints
//    func setupValuesPickerView() {
//        valuesPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        valuesPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
//        valuesPickerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        valuesPickerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//    }
    
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
        findTimeOfDay()
        
        valuesPickerView.dataSource = self
        valuesPickerView.delegate = self
        
        view.addSubview(labelStack)
        setupLabelStack()
        
//        valuesPickerView.subviews[1].backgroundColor = UIColor.white
//        valuesPickerView.subviews[2].backgroundColor = UIColor.white
        
        
        //view.addSubview(valuesPickerView)
        //setupValuesPickerView()
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


extension UIPickerView {
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if subview.bounds.height < 1.0 {
            subview.backgroundColor = UIColor.white
        }
    }
    
    
}



