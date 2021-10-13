//
//  PasteViewController.swift
//  PasteViewController
//
//  Created by zhgchgli on 2021/8/27.
//

import UIKit

class PasteViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func loadPaste(_ sender: Any) {
        textView.text = UIPasteboard.general.string
    }
    
    
    @IBAction func loadPasteIfItsURL(_ sender: Any) {
        let r:Set<PartialKeyPath<UIPasteboard.DetectedValues>> = [\UIPasteboard.DetectedValues.probableWebURL]
        UIPasteboard.general.detectPatterns(for: r) { result in
            switch result {
            case .success(let success):
                if success.contains(\UIPasteboard.DetectedValues.probableWebURL) {
                    DispatchQueue.main.async {
                        self.textView.text = UIPasteboard.general.string
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
