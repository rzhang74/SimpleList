//
//  PersonalViewController.swift
//  A_Simple_List
//
//  Created by Derek Wu on 2017/1/7.
//  Copyright © 2017年 Xintong Wu. All rights reserved.
//

import Foundation
import UIKit
import Charts

//Global Variable
var dueTotalHour: Double = 3.0 //record total hours in the forcus mode
var totalTaskCount: Double = 12.0 //count the number of tasks user input
var finishedTaskCount: Double = 2.0 //count the number of tasks that are finished
var failedTaskCount: Double = 3.0 //count the number of tasks that are not finished before the due

var contentList = ["FocusHour", "Total Tasks", "Finished Tasks", "Failed Tasks"]
var countList = [dueTotalHour, totalTaskCount, finishedTaskCount, failedTaskCount]


class PersonalViewController: UIViewController_, UITableViewDelegate, UITableViewDataSource{
    
    //Links
    @IBOutlet weak var ContentList: UITableView!
    @IBOutlet weak var statusBar: UILabel!
    
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

    
    //Gesture Control
    //Right to left Edge Pan Gesture
    func createRightEdgePanGestureRecognizer(targetView: UIView){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.RightEdgePanHandler(_:)))
        edgePan.edges = .right
        targetView.addGestureRecognizer(edgePan)
    }
    func RightEdgePanHandler(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LVC")
            self.present(secondViewController!, animated: false, completion: nil)
        }
    }
    

    //Functions
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4 //Four cells
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0){
            return 0
        }
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = background_
        return view
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: ContentListCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContentListCell
        cell.contentLabel.text = contentList[indexPath[0]]
        print(totalTaskCount)
        print(contentList[indexPath[0]])
        print(countList[indexPath[0]])
        cell.numberLabel.text = String(countList[indexPath[0]])
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ContentList.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshStatusBar()
        
        // Do any additional setup after loading the view, typically from a nib.
        var rect = view.bounds
        rect.origin.y = -130
        rect.size.height -= 40
        let chartView = PieChartView(frame: rect)
        let inprogress = totalTaskCount-finishedTaskCount-failedTaskCount
        let entries = [
            PieChartDataEntry(value: inprogress, label: "In Progress"),
            PieChartDataEntry(value: finishedTaskCount, label: "Finished"),
            PieChartDataEntry(value: failedTaskCount, label: "Failed")
        ]
        let set = PieChartDataSet(values: entries, label: "Data")
        set.highlightEnabled = false //highlight color?
        set.valueTextColor = grey_ //text color 总的
        set.entryLabelColor = background_ //label color
        //other settings: change something in the piechart view
        
        
        set.colors = [green_, yellow_, red_]//set the color
        chartView.data = PieChartData(dataSet: set)
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)//, easingX: .EaseInCubic, easingY: .EaseInCubic)
        chartView.legend.enabled = false
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        view.addSubview(chartView)
        
        createRightEdgePanGestureRecognizer(targetView: self.view)
        createRightEdgePanGestureRecognizer(targetView: self.ContentList)
        createRightEdgePanGestureRecognizer(targetView: chartView)
        
        //Disable scroll
        ContentList.isScrollEnabled = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
