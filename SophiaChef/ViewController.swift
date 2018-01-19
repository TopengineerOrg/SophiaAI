//
//  ViewController.swift
//  SophiaChef
//
//  Created by Galileo Guzman on 1/19/18.
//  Copyright © 2018 Galileo Guzman. All rights reserved.
//

import UIKit
import AVFoundation
import ApiAI

class ViewController: UIViewController {

    // PROPERTIES
    let speechSynthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var lblResponse: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // SELF METHODS
    private func initController(){
        self.speechAndText(text: "Welcome, I'm Sophia the Chef")
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.lblResponse.text = text
        }, completion: nil)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        let request = ApiAI.shared().textRequest()
        
        if let text = self.txtMessage.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        txtMessage.text = ""
        
        
    }

}

