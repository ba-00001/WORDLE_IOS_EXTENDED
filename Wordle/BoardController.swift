import Foundation
import UIKit

class BoardController: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    var numItemsPerRow = 5
    var numRows = 6
    let collectionView: UICollectionView
    var goalWord: [String]
    var numGuesses = 0
    var currRow: Int {
        return numGuesses / numItemsPerRow
    }

    // Initialize settings variable
    var settings: [String: Any] = [:]

    // Initialize isAlienWordle property
    var isAlienWordle: Bool = false

    // Define placeholder keys
    let kNumLettersKey = "NumLettersKey"
    let kNumGuessesKey = "NumGuessesKey"
    let kWordThemeKey = "WordThemeKey"
    let kIsAlienWordleKey = "IsAlienWordleKey"

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.goalWord = WordGenerator.generateRandomWord()!.map { String($0) }
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - Public Methods
    func enter(_ string: String) {
        guard numGuesses < numItemsPerRow * numRows else { return }
        let cell = collectionView.cellForItem(at: IndexPath(item: numGuesses, section: 0)) as! LetterCell
        cell.set(letter: string)
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.autoreverse],
                       animations: {
            cell.transform = cell.transform.scaledBy(x: 1.05, y: 1.05)
        }, completion: { finished in
            cell.transform = CGAffineTransform.identity
        })
        if isFinalGuessInRow() {
            markLettersInRow()
        }
        numGuesses += 1
    }

    func deleteLastCharacter() {
        guard numGuesses > 0 && numGuesses % numItemsPerRow != 0 else { return }
        let cell = collectionView.cellForItem(at: IndexPath(item: numGuesses - 1, section: 0)) as! LetterCell
        numGuesses -= 1
        cell.clearLetter()
        cell.set(style: .initial)
    }

    // Exercise 1: Implement applyNumLettersSettings function
    func applyNumLettersSettings() {
        // Check if a value for numLetters exists in the settings dictionary
        if let numLetters = settings[kNumLettersKey] as? Int {
            // Assign numItemsPerRow to be equal to numLetters
            numItemsPerRow = numLetters
        }
    }

    // Exercise 2: Implement applyNumGuessesSettings function
    func applyNumGuessesSettings() {
        // Check if a value for numGuesses exists in the settings dictionary
        if let numGuesses = settings[kNumGuessesKey] as? Int {
            // Assign numRows to be equal to numGuesses
            numRows = numGuesses
        }
    }

    // Exercise 3: Implement applyThemeSettings function
    func applyThemeSettings() {
        // Fetch the theme value from the settings dictionary
        if let rawTheme = settings[kWordThemeKey] as? String,
            // Convert the string to the appropriate WordTheme enum case
            let theme = WordTheme(rawValue: rawTheme) {
            // Generate the goal word using the selected theme
            goalWord = WordGenerator.generateGoalWord(with: theme)
        }
    }

    // Exercise 4: Implement applyIsAlienWordleSettings function
    func applyIsAlienWordleSettings() {
        // Check if a value for isAlienWordle exists in the settings dictionary
        if let isAlienWordle = settings[kIsAlienWordleKey] as? Bool {
            // Assign isAlienWordle to the appropriate property
            self.isAlienWordle = isAlienWordle
        }
    }

    // Exercise 5: Define resetBoardWithCurrentSettings function
    func resetBoardWithCurrentSettings() {
        // Set numTimesGuessed to 0
        numGuesses = 0

        // Reload the collectionView
        collectionView.reloadData()
    }
}
