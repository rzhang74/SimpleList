//
//  InputViewController.swift
//  A_Simple_List
//
//  Created by Derek Wu on 2016/12/31.
//  Copyright © 2016年 Xintong Wu. All rights reserved.
//

import Foundation
import UIKit

//let Example_dueDate = time(year: 2017, month: 1, date: 7, hour: 3, minute: 19)
//let Example_create = time(year: 2017, month: 1, date: 5, hour: 8, minute: 12)

var preYPosition = 0.0

class InputViewController: UIViewController_{
    
    //Links
    @IBOutlet weak var InputTextField: UITextField!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var statusBar: UILabel!

    
    var min: Int = 0
    var hour: Int = 0
    var day: Int = 0
    var month: Int = 0
    var year: Int = 0
    let date = NSDate()
    let currentTime = Calendar.current
    
    //refresh status bar
    var count:Int = 0
    
    func refreshStatusBar(){
        
        refresh()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }
    
    func refresh(){
        
        UIView.transition(with: statusBar, duration: 1, options: [.transitionCrossDissolve], animations: {self.count += 1
            let hour = getCurrentTimeComponents().hour
            let minute = getCurrentTimeComponents().minute
            var minString = ""
            var hrString = ""
            if (self.count > 5 && self.count <= 10){
                self.statusBar.text = String(dueList.count) + " dues left"
                if (self.count == 10) {self.count = 0}}
            else{
                if (hour! < 10) {hrString = "0" + String(hour!)}
                else {hrString = String(hour!)}
                if (minute! < 10) {minString = "0" + String(minute!)}
                else {minString = String(minute!)}
                self.statusBar.text = hrString + ":" + minString
            }}, completion: nil)
    }
    
    var viewTransitionManager_reverse = ViewTransitionManager_reverse()
    
    //Handle swipe gesture
    func handleSwipes(_ sender : UISwipeGestureRecognizer){
        if(sender.direction == .up){
            print("Handling gesture - IVC")
            if (InputTextField.text != "")
            {
                print("add item: " + InputTextField.text!)
                //declare a new DueElement object
                
                //for getting current date
                let cur_date = NSDate()
                let calender = NSCalendar.current
                let components = calender.dateComponents([.year, .month, .day, .hour, .minute], from: cur_date as Date)
                let cur_dueDate = time(year: year, month: month, date: day, hour: hour, minute: min)
                let cur_create = time(year: components.year, month: components.month, date: components.day, hour: components.hour, minute: components.minute)
                let cur_dueElement = DueElement(dueName: InputTextField.text!, dueDate: cur_dueDate, createdDate: cur_create)
                /*Sort Start*/
                if dueList.isEmpty{
                    dueList.insert(cur_dueElement, at:0)
                }else{
                    var insertEnd = true
                    for i in 0...dueList.count-1{
                        if(cur_dueElement.timeLeft! < dueList[i].timeLeft!){
                            dueList.insert(cur_dueElement, at: i)
                            insertEnd = false
                            break
                        }
                    }
                    if(insertEnd){
                        dueList.append(cur_dueElement)
                    }
                }
                /*Sort End*/
                InputTextField.text = ""
                //add total task count
                totalTaskCount += 1
                print(totalTaskCount)
            }

            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LVC")
            secondViewController?.transitioningDelegate = self.viewTransitionManager_reverse
            self.present(secondViewController!, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //Draw the bottom line for the textfield
    //    override func viewDidLayoutSubviews() {
    //        let border = CALayer()
    //        let width = CGFloat(2.0)
    //        border.borderColor = UIColor.init(netHex:0x9B9B9B, isLargerAlpha: 0.7).cgColor
    //        border.frame = CGRect(x: 0, y: InputTextField.frame.size.height - width, width:  InputTextField.frame.size.width, height: InputTextField.frame.size.height)
    //        
    //        border.borderWidth = width
    //        InputTextField.layer.addSublayer(border)
    //        InputTextField.layer.masksToBounds = true
    //    }
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //refresh
        refreshStatusBar()

        
        //auto pop out keyboard
        self.InputTextField.becomeFirstResponder()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        year = currentTime.component(.year, from: date as Date)
        month = currentTime.component(.month, from: date as Date)
        day = currentTime.component(.day, from: date as Date)
        hour = currentTime.component(.hour, from: date as Date)
        min = currentTime.component(.minute, from: date as Date)
        minLabel.text = timeToString(time: min)
        hourLabel.text = timeToString(time: hour)
        dateLabel.text = timeToString(time: day)
        monthLabel.text = monthToString(month: month)
        yearLabel.text = String(year)
        minLabel.isUserInteractionEnabled = true
        hourLabel.isUserInteractionEnabled = true
        dateLabel.isUserInteractionEnabled = true
        monthLabel.isUserInteractionEnabled = true
        yearLabel.isUserInteractionEnabled = true
        let minPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(minPanedView(sender: )))
        let hrPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(hrPanedView(sender: )))
        let datePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(datePanedView(sender: )))
        let monthPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(monthPanedView(sender: )))
        let yrPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(yrPanedView(sender: )))
        
        self.minLabel.addGestureRecognizer(minPanRecognizer)
        self.hourLabel.addGestureRecognizer(hrPanRecognizer)
        self.dateLabel.addGestureRecognizer(datePanRecognizer)
        self.monthLabel.addGestureRecognizer(monthPanRecognizer)
        self.yearLabel.addGestureRecognizer(yrPanRecognizer)

    }
    
    func timeToString(time: Int)->String{
        if (time < 10) {return ("0" + String(time))}
        else {return String(time)}
    }
    
    func monthToString(month: Int)->String{
        if (month == 1) {return "Jan"}
        else if (month == 2) {return "Feb"}
        else if (month == 3) {return "Mar"}
        else if (month == 4) {return "Apr"}
        else if (month == 5) {return "May"}
        else if (month == 6) {return "Jun"}
        else if (month == 7) {return "Jul"}
        else if (month == 8) {return "Aug"}
        else if (month == 9) {return "Sep"}
        else if (month == 10) {return "Oct"}
        else if (month == 11) {return "Nov"}
        else if (month == 12) {return "Dec"}
        else {return ""}
    }
    
    
    func minPanedView(sender: UIPanGestureRecognizer){
        //        let translation = sender.translation(in: minLabel)
        //        let startPoint = CGPoint(x: 0, y: 0)
        //        sender.setTranslation(startPoint, in: minLabel)
        //        let currentLocation = translation.y
        //        min -= Int(currentLocation/5)
        var preYPosition = 0.0
        var currentYPosition = 0.0;
        if sender.state == UIGestureRecognizerState.began{
            preYPosition =  Double(sender.location(in: minLabel).y)
        }
        
        if sender.state == UIGestureRecognizerState.ended{
            preYPosition = 0.0
        }
        
        if sender.state == UIGestureRecognizerState.changed{
            currentYPosition = Double(sender.location(in: minLabel).y)
            if(currentYPosition-preYPosition >= 2){
                min-=1
            }
            else if(currentYPosition-preYPosition <= -2){
                min+=1
            }
            usleep(180000)
            preYPosition = currentYPosition
        }
        //
        if (min < 0) {min = 59}
        if (min > 59) {min = 0}
        UIView.transition(with: minLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {self.minLabel.text = self.timeToString(time: self.min)}, completion: nil)
    }
    
    func hrPanedView(sender: UIPanGestureRecognizer){
        var preYPosition = 0.0
        var currentYPosition = 0.0;
        if sender.state == UIGestureRecognizerState.began{
            preYPosition =  Double(sender.location(in: hourLabel).y)
        }
        
        if sender.state == UIGestureRecognizerState.ended{
            preYPosition = 0.0
        }
        
        if sender.state == UIGestureRecognizerState.changed{
            currentYPosition = Double(sender.location(in: hourLabel).y)
            if(currentYPosition-preYPosition >= 2){
                hour-=1
            }
            else if(currentYPosition-preYPosition <= -2){
                hour+=1
            }
            usleep(180000)
            preYPosition = currentYPosition
        }
        
        if (hour < 0) {hour = 23}
        if (hour > 23) {hour = 0}
        UIView.transition(with: hourLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {self.hourLabel.text = self.timeToString(time: self.hour)}, completion: nil)
    }
    
    func datePanedView(sender: UIPanGestureRecognizer){
        var preYPosition = 0.0
        var currentYPosition = 0.0;
        if sender.state == UIGestureRecognizerState.began{
            preYPosition =  Double(sender.location(in: dateLabel).y)
        }
        
        if sender.state == UIGestureRecognizerState.ended{
            preYPosition = 0.0
        }
        
        if sender.state == UIGestureRecognizerState.changed{
            currentYPosition = Double(sender.location(in: dateLabel).y)
            if(currentYPosition-preYPosition >= 2){
                day-=1
            }
            else if(currentYPosition-preYPosition <= -2){
                day+=1
            }
            usleep(180000)
            preYPosition = currentYPosition
        }
        
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
            if (day < 1) {day = 31}
            if (day > 31) {day = 1}
        }
        if (month == 2){
            if (year == 2020  || year == 2024) {
                if (day < 1) {day = 29}
                if (day > 29) {day = 1}
            }
            else {
                if (day < 1) {day = 28}
                if (day > 28) {day = 1}
            }
        }
        else {
            if (day < 1) {day = 30}
            if (day > 30) {day = 1}
        }
        UIView.transition(with: dateLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {self.dateLabel.text = self.timeToString(time: self.day)}, completion: nil)
    }
    
    func monthPanedView(sender: UIPanGestureRecognizer){
        var preYPosition = 0.0
        var currentYPosition = 0.0;
        if sender.state == UIGestureRecognizerState.began{
            preYPosition =  Double(sender.location(in: monthLabel).y)
        }
        
        if sender.state == UIGestureRecognizerState.ended{
            preYPosition = 0.0
        }
        
        if sender.state == UIGestureRecognizerState.changed{
            currentYPosition = Double(sender.location(in: monthLabel).y)
            if(currentYPosition-preYPosition >= 2){
                month-=1
            }
            else if(currentYPosition-preYPosition <= -2){
                month+=1
            }
            usleep(200000)
            preYPosition = currentYPosition
        }
        
        if (month < 1) {month = 12}
        if (month > 12) {month = 1}
        UIView.transition(with: monthLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {self.monthLabel.text = self.monthToString(month: self.month)}, completion: nil)
    }
    
    func yrPanedView(sender: UIPanGestureRecognizer){
        var preYPosition = 0.0
        var currentYPosition = 0.0;
        if sender.state == UIGestureRecognizerState.began{
            preYPosition =  Double(sender.location(in: yearLabel).y)
        }
        
        if sender.state == UIGestureRecognizerState.ended{
            preYPosition = 0.0
        }
        
        if sender.state == UIGestureRecognizerState.changed{
            currentYPosition = Double(sender.location(in: yearLabel).y)
            if(currentYPosition-preYPosition >= 2){
                year-=1
            }
            else if(currentYPosition-preYPosition <= -2){
                year+=1
            }
            usleep(200000)
            preYPosition = currentYPosition
        }
        
        UIView.transition(with: yearLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {self.yearLabel.text = String(self.year)}, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //hide keyboard when user touch outside area of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
//    //hide when press return
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        InputTextField.resignFirstResponder()
//        return true
//    }
    
}
