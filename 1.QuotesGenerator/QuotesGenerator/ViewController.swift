//
//  ViewController.swift
//  QuotesGenerator
//
//  Created by Muker on 2022/06/28.
//

import UIKit

// MVC 중 M
struct QuoteList {
    let contents: String
    let name: String
}

// MVC 중 C
class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let quotes = [
        QuoteList(contents: "안녕 반갑다", name: "원강묵"),
        QuoteList(contents: "안녕 안 반갑다", name: "심승오"),
        QuoteList(contents: "Hi Every One", name: "샘스미스"),
        QuoteList(contents: "누구세용", name: "이재용"),
        QuoteList(contents: "삼성 조아", name: "팀쿡"),
        QuoteList(contents: "애플 조아", name: "옆집 강아지")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func quoteActionButton(_ sender: UIButton) {
        let random = Int(arc4random_uniform(6))
        let quote = quotes[random]
        self.quoteLabel.text = quote.contents
        self.nameLabel.text = quote.name
    }
    
}

