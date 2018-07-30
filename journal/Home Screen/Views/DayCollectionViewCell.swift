//
//  DayCollectionViewCell.swift
//  journal
//
//  Created by Amber Spadafora on 7/25/18.
//  Copyright © 2018 Amber Spadafora. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var progressView: ProgressCircleGraph!
    @IBOutlet weak var taskTableTopConstraint: NSLayoutConstraint!
    

    var isExpanded: Bool = false {
        didSet {
            switch  isExpanded {
            case true:
                setConstraintsForExpandedCell()
            case false:
                setConstraintsForMinimizedCell()
            }
        }
    }
    
    var task: [Task] = []
    
    let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.strikethroughColor : UIColor.black, .strikethroughStyle : 1]
    
    var weekDay: WeekDay? {
        didSet {
            self.dayLabel.text = weekDay?.rawValue
        }
    }
    
    private func setConstraintsForExpandedCell() {
        taskTableTopConstraint.constant = self.progressView.bounds.height + 32.0
        self.progressView.isHidden = false
        let progress: Float = Float(task.filter{ $0.isComplete }.count) / Float(task.count)

        self.progressView.drawCircle()
        self.progressView.setProgressWithAnimation(duration: 1.0, value: progress)
        
    }
    
    private func setConstraintsForMinimizedCell() {
        progressView.isHidden = true
        taskTableTopConstraint.constant = 8.0
    }
    
}

extension DayCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = task[indexPath.row].description
        return cell
    }
    
    
}
