//
//  ViewController.swift
//  journal
//
//  Created by Amber Spadafora on 7/24/18.
//  Copyright © 2018 Amber Spadafora. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak private var scheduleCollectionView: UICollectionView!
    @IBOutlet weak private var dailyPlannerLabel: UILabel!
    
    private var originalCollectionViewFrame: CGRect? = nil
    private var partiallyExpandedCollectionViewFrame: CGRect? = nil
    private var completelyExpandedCollectionViewFrame: CGRect? = nil
    
    private lazy var frameSizes = [self.originalCollectionViewFrame, self.partiallyExpandedCollectionViewFrame, self.completelyExpandedCollectionViewFrame]
    
    private var indexOfCurrentFrameSize = 0 {
        didSet {
            self.dailyPlannerLabel.isHidden = (indexOfCurrentFrameSize == 2)
            indexOfCurrentFrameSize = (indexOfCurrentFrameSize > frameSizes.count - 1) ? 0 : indexOfCurrentFrameSize
            
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations:
                { [weak self] in
                    guard let vc = self, let currentFrameSize = vc.frameSizes[vc.indexOfCurrentFrameSize] else { return }
                    vc.scheduleCollectionView.collectionViewLayout.invalidateLayout()
                    vc.scheduleCollectionView.frame = currentFrameSize
                }, completion: nil)
        }
    }
    
    private var currentPage = 0
    
    private let weekdays: [WeekDay] = [.sun, .mon, .tues, .wed, .thurs, .fri, .sat]
    
    private let mockTasks = [Task(description: "task1", isComplete: true, dayOfWeek: .mon),
                     Task(description: "task2", isComplete: true, dayOfWeek: .mon),
                     Task(description: "task1", isComplete: false, dayOfWeek: .mon)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundView()
        setUpSwipeGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        let heightOfCollectionView = scheduleCollectionView.frame.height
        let widthOfCollectionView = scheduleCollectionView.frame.width
        let partiallyExpandedHeightOfCollectionView = heightOfCollectionView * 1.25
        let completelyExpandedHeightOfCollectionView = self.view.bounds.height - 32.0
        
        originalCollectionViewFrame = CGRect(x: 16, y: view.frame.maxY - 16.0 - heightOfCollectionView, width: widthOfCollectionView, height: heightOfCollectionView)
        
        partiallyExpandedCollectionViewFrame = CGRect(x: 16, y: view.frame.maxY - 16.0 - partiallyExpandedHeightOfCollectionView, width: widthOfCollectionView, height: partiallyExpandedHeightOfCollectionView)
        
        completelyExpandedCollectionViewFrame = CGRect(x: 16, y: view.frame.maxY - 16.0 - completelyExpandedHeightOfCollectionView, width: widthOfCollectionView, height: completelyExpandedHeightOfCollectionView)
    }
}

// MARK: - CollectionView Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = scheduleCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? DayCollectionViewCell else { fatalError() }
        
        dayCell.layer.cornerRadius = 18.0
        dayCell.weekDay = weekdays[indexPath.row]
        dayCell.taskTableView.delegate = dayCell
        dayCell.taskTableView.dataSource = dayCell
        dayCell.task = mockTasks
        dayCell.setConstraintsForMinimizedCell()
        return dayCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexOfCurrentFrameSize += 1
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else { return }
        cell.isExpanded = indexOfCurrentFrameSize != 0
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topContentInset = scheduleCollectionView.contentInset.top
        let bottomContentInset = scheduleCollectionView.contentInset.bottom
        
        return CGSize(width: scheduleCollectionView.frame.width, height: scheduleCollectionView.frame.height - topContentInset - bottomContentInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}

// MARK: - Helper Methods
extension HomeViewController {
    private func setUpBackgroundView() {
        let backgroundView = UIView(frame: view.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)].map{$0.cgColor}
        backgroundView.layer.addSublayer(gradientLayer)
        view.insertSubview(backgroundView, at: 0)
    }
    
    private func setUpSwipeGestureRecognizers() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(snapToNextCell))
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(snapToPreviousCell))
        swipeRightGesture.direction = .right
        swipeLeftGesture.direction = .left
        scheduleCollectionView.addGestureRecognizer(swipeLeftGesture)
        scheduleCollectionView.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc func snapToNextCell(_ sender: UISwipeGestureRecognizer) {
        if currentPage + 1 < scheduleCollectionView.numberOfItems(inSection: 0) {
            scheduleCollectionView.collectionViewLayout.invalidateLayout()
            indexOfCurrentFrameSize = 0
            scheduleCollectionView.scrollToItem(at: IndexPath(row: currentPage + 1, section: 0), at: .left, animated: true)
            currentPage += 1
        }
    }
    
    @objc func snapToPreviousCell(_ sender: UISwipeGestureRecognizer) {
        if currentPage - 1 >= 0 {
            scheduleCollectionView.collectionViewLayout.invalidateLayout()
            indexOfCurrentFrameSize = 0
            scheduleCollectionView.scrollToItem(at: IndexPath(row: currentPage - 1, section: 0), at: .left, animated: true)
            currentPage -= 1
        }
    }
}


