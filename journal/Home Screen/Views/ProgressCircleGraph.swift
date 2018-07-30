//
//  ProgressCircleGraph.swift
//  journal
//
//  Created by Amber Spadafora on 7/26/18.
//  Copyright © 2018 Amber Spadafora. All rights reserved.
//

import UIKit

class ProgressCircleGraph: UIView {
    
    private let animatedProgressLayer = CAShapeLayer()
    private let backgroundCircleLayer = CAShapeLayer()
    private let gradientFillLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawCircle() {
        let backgroundCircle = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: ((self.bounds.height - 8.0) / 2), startAngle: 0, endAngle: (2 * CGFloat.pi) , clockwise: true).cgPath
        
        backgroundCircleLayer.path = backgroundCircle
        backgroundCircleLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeEnd = 1.0
        backgroundCircleLayer.lineWidth = 8.0
        layer.addSublayer(backgroundCircleLayer)
        
        
        let progressPathBounds: CGRect = layer.bounds
        
        animatedProgressLayer.fillColor = UIColor.clear.cgColor
        animatedProgressLayer.strokeColor = UIColor.lightGray.cgColor
        animatedProgressLayer.frame = progressPathBounds
        animatedProgressLayer.path = backgroundCircle
        animatedProgressLayer.lineWidth = 8.0
        animatedProgressLayer.strokeEnd = 0.0
        
        let startPoint = CGPoint(x: 0.0, y: 1.0)
        let endPoint = CGPoint(x: 0.5, y: 0.0)
        
        gradientFillLayer.startPoint = startPoint
        gradientFillLayer.endPoint = endPoint
        gradientFillLayer.colors = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)].map{$0.cgColor}
        gradientFillLayer.frame = progressPathBounds
        gradientFillLayer.mask = animatedProgressLayer
        
        layer.addSublayer(gradientFillLayer)
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animatedProgressLayer.add(animation, forKey: "animateProgress")
    }
    
    
    
}
