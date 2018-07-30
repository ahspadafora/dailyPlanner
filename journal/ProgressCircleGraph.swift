//
//  ProgressCircleGraph.swift
//  journal
//
//  Created by Amber Spadafora on 7/26/18.
//  Copyright © 2018 Amber Spadafora. All rights reserved.
//

import UIKit

class ProgressCircleGraph: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //drawCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //drawCircle()
    }
    
    func drawCircle() {
        let outerCircle = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: ((self.bounds.height - 8.0) / 2), startAngle: 0, endAngle: (2 * CGFloat.pi) , clockwise: true).cgPath
        print(self.bounds.height)
        trackLayer.path = outerCircle
        trackLayer.strokeColor = UIColor.black.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeEnd = 1.0
        trackLayer.lineWidth = 8.0
        layer.addSublayer(trackLayer)
        
        
        let progressPathBounds: CGRect = layer.bounds
        progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.frame = progressPathBounds
        progressLayer.path = outerCircle
        progressLayer.lineWidth = 8.0
        progressLayer.strokeEnd = 0.0
        
        let startPoint = CGPoint(x: 0.0, y: 1.0)
        let endPoint = CGPoint(x: 0.5, y: 0.0)
        self.gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)].map{$0.cgColor}
        gradientLayer.frame = progressPathBounds
        gradientLayer.mask = progressLayer
        
        layer.addSublayer(gradientLayer)
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        progressLayer.add(animation, forKey: "animateprogress")
    }
    
    
    
}
