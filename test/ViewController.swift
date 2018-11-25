//
//  ViewController.swift
//  test
//
//  Created by Jogesh Ghadai on 17/11/18.
//  Copyright © 2018 Jogesh Ghadai. All rights reserved.
//

import Cocoa

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
}

class ViewController: NSViewController {

    @IBOutlet weak var buttonOutlet: NSButton!
    @IBOutlet weak var indicator: NSProgressIndicator!
    @IBOutlet var htmlShow: NSTextView!
    @IBOutlet weak var inUrl: NSTextField!
    var counter = 0
    var timer = Timer()
    var startClicked = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOutlet.toolTip = "Press to START"
        buttonOutlet.title = "Start Crawling"
    }

    @IBAction func searchAct(_ sender: Any) {
        if timer.isValid {
            buttonOutlet.title = "Start Crawling"
            buttonOutlet.toolTip = "Press to START"
            timer.invalidate()
            htmlShow.string = ""
            counter = 0
            alert(msg: "Process Stopped!", info: "Start Again to Start.")
        }
        else{
            buttonOutlet.title = "Stop Crawling"
            buttonOutlet.toolTip = "Press to STOP"
            alert(msg: "Process Started!", info: "Press the Button again to Stop.")
            runFetch()
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runFetch), userInfo: nil, repeats: true)
        }
    }
    
    @objc func runFetch() {
        if inUrl.stringValue != "" {
            var runsStat = ""
            htmlShow.string = ""
            indicator.isHidden = false
            indicator.startAnimation(self)
            let myURLString = inUrl.stringValue
            guard let myURL = URL(string: myURLString) else {
                indicator.stopAnimation(self)
                indicator.isHidden = true
                self.alert(msg: "Invalid URL!", info: "\(myURLString) is INVALID URL. Please Enter a VALID One. STOP AND START AGAIN.")
                return
            }
            DispatchQueue.global().async {
                do {
                    let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                    if let ind = myHTMLString.index(of: "NZ 153, ") {
                        runsStat = String((myHTMLString[myHTMLString.index(ind, offsetBy: 0)...])[..<myHTMLString.index(ind, offsetBy: 24)])
                        sleep(1)
                        DispatchQueue.main.async {
                            self.indicator.isHidden = true
                            self.indicator.stopAnimation(self)
                            self.counter += 1
                            self.htmlShow.string = "\(self.counter) #############  \(runsStat)  #############\n\n\n\(myHTMLString)"
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.indicator.isHidden = true
                            self.indicator.stopAnimation(self)
                            self.alert(msg: "MATCH NOT FOUND!", info: "Match page has been changed. Please Check.  STOP AND START AGAIN.")
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                        self.indicator.stopAnimation(self)
                        self.alert(msg: "ERROR OCCURED!", info: "DATA from the URL Couldn't be fetched due to :\n\(error)\n STOP AND START AGAIN.")
                    }
                }
            }
        }
        else {
            alert(msg: "Empty URL Field!", info: "Please Enter an URL first. STOP AND START AGAIN.")
        }
    }
    
    func alert(msg : String, info : String) {
        let alt = NSAlert()
        alt.messageText = msg
        alt.informativeText = info
        alt.addButton(withTitle: "OK")
        alt.runModal()
    }
}

