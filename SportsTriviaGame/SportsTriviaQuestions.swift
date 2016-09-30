//
//  SportsTriviaQuestions.swift
//  SportsTriviaGame
//
//  Created by Alexander Nelson on 9/19/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import Foundation


enum SportsTriviaError: Error {
    case invalidResource
    case conversionError
    case invalidKey
}

class SportsTrivia {
    let description: String
    let year: Int
    let url: String

    init(description: String, year: Int, url: String) {
        self.description = description
        self.year = year
        self.url = url
    }
}

struct GameOfSportsTrivia {
    var sportsTriviaOptions: [SportsTrivia]

    init(sportsTrivia: [SportsTrivia]) {
        self.sportsTriviaOptions = sportsTrivia
    }
}

class PlistConverter {
    class func arrayFromFile(resource: String, ofType type: String) throws -> [[String : String]] {

        guard let path =
            Bundle.main.path(forResource: resource, ofType: type) else {
                throw SportsTriviaError.invalidResource
        }

        guard let array = NSArray(contentsOfFile: path),
            let castArray = array as? [[String: String]] else {
                throw SportsTriviaError.conversionError
        }
        return castArray
    }
}


class SportsTriviaUnarchiver {
    class func sportsTriviaFromArray(array: [[String : String]]) -> [SportsTrivia] {

        var sportsTriviaArray: [SportsTrivia] = []

        for sportsTriviaEvent in array {
            if let description = sportsTriviaEvent["description"], let year = sportsTriviaEvent["year"],
                let yearInt = Int(year),
                let url = sportsTriviaEvent["url"] {
                let newSportsTriviaEvent = SportsTrivia(description: description, year: yearInt, url: url)
                sportsTriviaArray.append(newSportsTriviaEvent)
            }
        }
        return sportsTriviaArray
    }
}





