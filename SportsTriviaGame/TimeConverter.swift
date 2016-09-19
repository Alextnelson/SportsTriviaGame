//
//  TimeConverter.swift
//  SportsTriviaGame
//
//  Created by Alexander Nelson on 9/19/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

//just for fun
class TimeConverter {

    init(){}

    static func timeStringfrom(timeInSeconds: Int) -> String {

        let minutes: Int = timeInSeconds / 60
        let seconds: Int = timeInSeconds % 60
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"

        return "\(minutes):\(secondsString)"
    }
}
