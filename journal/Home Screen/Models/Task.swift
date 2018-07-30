//
//  Task.swift
//  journal
//
//  Created by Amber Spadafora on 7/26/18.
//  Copyright © 2018 Amber Spadafora. All rights reserved.
//

import Foundation

struct Task {
    var description: String
    var isComplete: Bool
    var dayOfWeek: WeekDay
}

enum WeekDay: String {
    case mon = "Monday"
    case tues = "Tuesday"
    case wed = "Wednesday"
    case thurs = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
    
    var allCases: [WeekDay] {
        return [.mon, .tues, .wed, .thurs, .fri, .sat, .sun]
    }
}
