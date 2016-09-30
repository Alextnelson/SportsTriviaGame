//
//  SportsTriviaViewController.swift
//  SportsTriviaGame
//
//  Created by Alexander Nelson on 9/19/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class SportsTriviaViewController: UIViewController {


    // MARK: Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var shakeToCompleteInstructions: UILabel!

    @IBOutlet weak var eventLabelOne: UILabel!
    @IBOutlet weak var eventLabelTwo: UILabel!
    @IBOutlet weak var eventLabelThree: UILabel!
    @IBOutlet weak var eventLabelFour: UILabel!

    @IBOutlet weak var eventButtonOne: UIButton!
    @IBOutlet weak var eventButtonTwo: UIButton!
    @IBOutlet weak var eventButtonThree: UIButton!
    @IBOutlet weak var eventButtonFour: UIButton!

    @IBOutlet weak var fullDownButton: UIButton!
    @IBOutlet weak var halfUpButtonOne: UIButton!
    @IBOutlet weak var halfDownButtonOne: UIButton!
    @IBOutlet weak var halfUpButtonTwo: UIButton!
    @IBOutlet weak var halfDownButtonTwo: UIButton!
    @IBOutlet weak var fullUpButton: UIButton!

    @IBOutlet weak var nextRoundButton: UIButton!


    var allSportsTrivia: GameOfSportsTrivia
    var roundOfSportsTrivia = GameOfSportsTrivia(sportsTrivia: [])
    var sortedSportsTrivia = GameOfSportsTrivia(sportsTrivia: [])
    var eventButtons: [UIButton] = []
    var eventLabels: [UILabel] = []

    let roundsPerGame = 6
    let eventsPerRound = 4
    var roundsPlayed = 0
    var score = 0
    var correctAnswers = 0
    
    var seconds = 30
    var timer = Timer()
    var timerRunning = false

    let nextRoundFailImage = UIImage(named: "next_round_fail" )
    let nextRoundSuccessImage = UIImage(named: "next_round_success")

    var correctAnswerSound: SystemSoundID = 0
    var wrongAnswerSound: SystemSoundID = 0

    // Initializer to unarchive plist file of sports trivia
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile(resource: "SportsEvents", ofType: "plist")
            let sportsTriviaEvents = SportsTriviaUnarchiver.sportsTriviaFromArray(array: array)
            self.allSportsTrivia = GameOfSportsTrivia(sportsTrivia: sportsTriviaEvents)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()

    }

    func startNewRound() {
        if roundsPlayed < roundsPerGame {
            disableEventButtonsEnableSwitchButtons()
            resetTimer()
            shakeToCompleteInstructions.isHidden = false
            roundOfSportsTrivia.sportsTriviaOptions.removeAll()
            createSportsTriviaOptions(triviaRound: allSportsTrivia)
            setUpEventLabels(trivia: roundOfSportsTrivia)
            beginTimer()
            nextRoundButton.isHidden = true
            instructionLabel.text = "Order the events chronologically"
        } else {
            if let scoreViewController = storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController {
                present(scoreViewController, animated: true, completion: nil)
                scoreViewController.scoreLabel.text = "\(correctAnswers)/\(roundsPerGame)"
            }
            resetGame()
        }

    }


    @IBAction func changeLabels(_ sender: UIButton) {
        switch sender {
        case fullDownButton, halfUpButtonOne: swapElements(fromIndex: 1, toIndex: 0)
        case halfDownButtonOne, halfUpButtonTwo: swapElements(fromIndex: 2, toIndex: 1)
        case fullUpButton, halfDownButtonTwo: swapElements(fromIndex: 3, toIndex: 2)
        default: break
        }
    }

    func setUpEventLabels(trivia: GameOfSportsTrivia) {
        var triviaTitles = [String]()

        for eventTitles in trivia.sportsTriviaOptions {
            triviaTitles.append(eventTitles.description)
        }
        eventLabels = [eventLabelOne, eventLabelTwo, eventLabelThree, eventLabelFour]
        for label in eventLabels {
            label.text = triviaTitles.removeLast()
        }
    }

    func swapElements(fromIndex: Int, toIndex: Int) {
        swap(&eventLabels[fromIndex].text, &eventLabels[toIndex].text)
    }

    func createSportsTriviaOptions(triviaRound: GameOfSportsTrivia) {
        let randomizedSportsTrivia = GameOfSportsTrivia(sportsTrivia: GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allSportsTrivia.sportsTriviaOptions) as! [SportsTrivia])

        for sportsTrivia in randomizedSportsTrivia.sportsTriviaOptions {
            if roundOfSportsTrivia.sportsTriviaOptions.count < eventsPerRound {
                roundOfSportsTrivia.sportsTriviaOptions.append(sportsTrivia)
            }
        }
    }

    func sortedTrivia(trivia: GameOfSportsTrivia) -> [SportsTrivia] {
        return trivia.sportsTriviaOptions.sorted { $0.year < $1.year }
    }

    func checkAnswer() {
        roundsPlayed += 1
        timer.invalidate()
        sortedSportsTrivia.sportsTriviaOptions = sortedTrivia(trivia: roundOfSportsTrivia)
        enableEventButtonsDisableSwitchButtons()
        shakeToCompleteInstructions.isHidden = true

        if eventLabelOne.text == sortedSportsTrivia.sportsTriviaOptions[0].description && eventLabelTwo.text == sortedSportsTrivia.sportsTriviaOptions[1].description && eventLabelThree.text == sortedSportsTrivia.sportsTriviaOptions[2].description && eventLabelFour.text == sortedSportsTrivia.sportsTriviaOptions[3].description {
            correctAnswers += 1
            nextRoundButton.isHidden = false
            nextRoundButton.setImage(nextRoundSuccessImage, for: .normal)
            correctLabels()
            instructionLabel.text = "You are correct! Click on events to learn more"

        } else {
            nextRoundButton.isHidden = false
            nextRoundButton.setImage(nextRoundFailImage, for: .normal)
            correctLabels()
            instructionLabel.text = "Sorry, that is incorrect. Click on events to learn more."
        }
    }

    @IBAction func startNextRound(_ sender: UIButton) {
        startNewRound()
        disableEventButtonsEnableSwitchButtons()
    }


    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAnswer()
        }
    }

    // MARK: Segue for Web view

    @IBAction func presentWebViewOne(_ sender: AnyObject) {
        performSegue(withIdentifier: "webViewSegueOne", sender: self)
    }
    
    @IBAction func presentWebViewTwo(_ sender: AnyObject) {
        performSegue(withIdentifier: "webViewSegueTwo", sender: self)
    }

    @IBAction func presentWebViewThree(_ sender: AnyObject) {
        performSegue(withIdentifier: "webViewSegueThree", sender: self)
    }

    @IBAction func presentWebViewFour(_ sender: AnyObject) {
        performSegue(withIdentifier: "webViewSegueFour", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegueOne", let wvc = segue.destination as? WebViewController {
            wvc.url = sortedSportsTrivia.sportsTriviaOptions[0].url
        } else if segue.identifier == "webViewSegueTwo", let wvc = segue.destination as? WebViewController {
            wvc.url = sortedSportsTrivia.sportsTriviaOptions[1].url
        } else if segue.identifier == "webViewSegueThree", let wvc = segue.destination as? WebViewController {
            wvc.url = sortedSportsTrivia.sportsTriviaOptions[2].url
        } else if segue.identifier == "webViewSegueFour", let wvc = segue.destination as? WebViewController {
            wvc.url = sortedSportsTrivia.sportsTriviaOptions[3].url
        }
    }


    // MARK: Helper methods

    func enableLearnMoreButtons() {
        print("Something")
    }

    func resetGame() {
        correctAnswers = 0
        roundsPlayed = 0
        startNewRound()
    }

    func disableEventButtonsEnableSwitchButtons() {
        eventButtonOne.isEnabled = false
        eventButtonTwo.isEnabled = false
        eventButtonThree.isEnabled = false
        eventButtonFour.isEnabled = false

        fullDownButton.isEnabled = true
        halfUpButtonOne.isEnabled = true
        halfDownButtonOne.isEnabled = true
        halfUpButtonTwo.isEnabled = true
        halfDownButtonTwo.isEnabled = true
        fullUpButton.isEnabled = true
    }

    func enableEventButtonsDisableSwitchButtons() {
        eventButtonOne.isEnabled = true
        eventButtonTwo.isEnabled = true
        eventButtonThree.isEnabled = true
        eventButtonFour.isEnabled = true

        fullDownButton.isEnabled = false
        halfUpButtonOne.isEnabled = false
        halfDownButtonOne.isEnabled = false
        halfUpButtonTwo.isEnabled = false
        halfDownButtonTwo.isEnabled = false
        fullUpButton.isEnabled = false

    }

    func correctLabels() {
        eventLabelOne.text = sortedSportsTrivia.sportsTriviaOptions[0].description
        eventLabelTwo.text = sortedSportsTrivia.sportsTriviaOptions[1].description
        eventLabelThree.text = sortedSportsTrivia.sportsTriviaOptions[2].description
        eventLabelFour.text = sortedSportsTrivia.sportsTriviaOptions[3].description
    }

// MARK: Timer methods

    func beginTimer() {
        if timerRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SportsTriviaViewController.startTimerCountdown), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }

    func startTimerCountdown () {
        seconds -= 1
        timerLabel.text = "00:\(seconds)"

        if seconds < 10 {
            timerLabel.text = "00:0\(seconds)"
        }

        if seconds == 0 {
            roundsPlayed += 1
            instructionLabel.text = "Time's Up!"
            checkAnswer()
        }
    }

    func resetTimer() {
        seconds = 30
        timerLabel.text = "00:\(seconds)"
        timerRunning = false
    }
}



