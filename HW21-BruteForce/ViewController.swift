//
//  ViewController.swift
//  HW21-BruteForce
//
//  Created by temp user on 08.08.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var changeColorButton: UIButton!
    @IBOutlet weak var bruteForceButton: UIButton!
    
    //MARK: - Properties
    lazy var password = ""
    var queue = DispatchQueue(label: "Brute", qos: .userInitiated)
    var isBlack: Bool = false {
        didSet {
                self.view.backgroundColor = isBlack ? .black : .white
                self.passwordLabel.textColor = isBlack ? .white : .black
                self.passwordTextField.textColor = isBlack ? .white : .black
                self.passwordTextField.backgroundColor = isBlack ? .gray : .white
                self.passwordTextField.tintColor = isBlack ? .black : .white
                self.indicator.color = isBlack ? .white : .black
        }
    }
    
    //MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidesWhenStopped = true
    }
    
    //MARK: - Actions
    @IBAction func onButBruteForce(_ sender: Any) {
        prepareForBrute()
        let brutePassword = passwordGeneration()
        passwordTextField.text = brutePassword
        let brute = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: brutePassword)
        }
        queue.async(execute: brute)
    }
    @IBAction func onButChangeColor(_ sender: Any) {
        isBlack.toggle()
    }
    
    //MARK: - Functions
    func prepareForBrute() {
        password = ""
        passwordTextField.isSecureTextEntry = true
        passwordLabel.text = "Ваш пароль"
        indicator.startAnimating()
        bruteForceButton.isEnabled = false
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

