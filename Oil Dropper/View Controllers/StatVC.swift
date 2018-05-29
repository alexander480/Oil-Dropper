//
//  StatVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/26/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit
import Foundation
import Charts

class StatVC: UIViewController, ChartViewDelegate {
    
    var gsrData = [Double]()
    
    @IBOutlet weak var chart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chart.delegate = self
        self.setupChartData()
    }
    
    private func setupChartData() {
        var chartData = [ChartDataEntry]()
        for i in 0..<gsrData.count { chartData.append(ChartDataEntry(x: Double(i), y: gsrData[i])) }
        
        let line = LineChartDataSet(values: chartData, label: "GSR Stress Level")
            line.colors = [UIColor.cyan]
            line.lineWidth = 1.5
            line.drawCircleHoleEnabled = false
            line.drawCirclesEnabled = false
            line.highlightColor = UIColor.black
            line.highlightLineWidth = 1.5
            line.mode = .cubicBezier
        
        self.initChart(Line: line)
    }

    private func initChart(Line: LineChartDataSet) {
        let data = LineChartData()
        data.addDataSet(Line)
        
        chart.data = data
        chart.chartDescription?.text = "GSR Data"
        chart.autoScaleMinMaxEnabled = true
        chart.isUserInteractionEnabled = true
        chart.drawGridBackgroundEnabled = false
        
        chart.xAxis.granularity = 1.0
        chart.xAxis.axisLineWidth = 1.5
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawGridLinesEnabled = true
        chart.xAxis.granularityEnabled = true
        chart.xAxis.drawLimitLinesBehindDataEnabled = true
        
        chart.leftAxis.granularity = 5
        chart.leftAxis.axisLineWidth = 1.5
        chart.leftAxis.labelPosition = .outsideChart
        chart.leftAxis.granularityEnabled = true
        chart.leftAxis.drawGridLinesEnabled = true
        
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
    }
}
