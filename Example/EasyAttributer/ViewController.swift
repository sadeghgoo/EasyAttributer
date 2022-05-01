//
//  ViewController.swift
//  EasyAttributer
//
//  Created by sadeq bitarafan on 10/05/2021.
//  Copyright (c) 2021 sadeghgoo. All rights reserved.
//

import UIKit
import EasyAttributer

struct UserMentionRegex: ESRegexBehavior {
    var group: ESRegexGroup = .init(partialTextIndex: 1)
    var pattern: String = "(@([^\\s@\\[\\]]+))\\[([^\\[\\]]+)\\]"
}

struct URLRegex: ESRegexBehavior {
    var group: ESRegexGroup = .init(partialTextIndex: nil)
    var pattern: String = "https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)"
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = "Hi @Merlia[AVV] how old are you?. This my website url: https://www.google.com"
        let parser = EasyAttributer(regexes: [UserMentionRegex(), URLRegex()])
        do {
            let attributedText = try parser.transform(text: str) { (result) -> [NSAttributedString.Key : Any] in
              if result.regex.pattern == UserMentionRegex().pattern {
                return [NSAttributedString.Key.foregroundColor : UIColor.systemOrange]
              } else {
                return [NSAttributedString.Key.foregroundColor : UIColor.systemBlue]
              }
                
            }
            textView.attributedText = attributedText
        } catch {
            print(error)
        }
        
        
    }
    
}

