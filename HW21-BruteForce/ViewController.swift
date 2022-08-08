//
//  ViewController.swift
//  HW21-BruteForce
//
//  Created by temp user on 08.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var butColor: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var butBruteForce: UIButton!
    
    //MARK: - Properties
    
    lazy var password = ""
    var queue = DispatchQueue(label: "Brute", qos: .userInitiated)
    var isBlack: Bool = false {
        didSet {
            view.backgroundColor = isBlack ? .black : .white
            self.label.textColor = isBlack ? .white : .black
            self.textField.textColor = isBlack ? .white : .black
            self.textField.backgroundColor = isBlack ? .gray : .white
            self.textField.tintColor = isBlack ? .black : .white
            self.indicator.color = isBlack ? .white : .black
        }
    }
    
    //MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidesWhenStopped = true
    }
    
    //MARK: - Actions
    @IBAction func onButColor(_ sender: Any) {
        isBlack.toggle()
    }
    @IBAction func onButBruteForce(_ sender: Any) {
        prepareForBrute()
        let brutePassword = passwordGeneration()
        textField.text = brutePassword
        let brute = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: brutePassword)
        }
        queue.async(execute: brute)
    }
    
    //MARK: - Functions
    func prepareForBrute() {
        password = ""
        textField.isSecureTextEntry = true
        label.text = "Ваш пароль"
        indicator.startAnimating()
        butBruteForce.isEnabled = false
    }
    
    func passwordGeneration () -> String {
        let char = String().printable.map { String($0) }
        for _ in 0 ..< 3 {
            password += char.randomElement() ?? ""
        }
        return password
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)
        }
        
        DispatchQueue.main.async {
            self.textField.isSecureTextEntry = false
            self.label.text = self.textField.text
            self.indicator.stopAnimating()
            self.butBruteForce.isEnabled = true
        }
        print(password)
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }
    
    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string
        
        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }
        return str
    }
}
