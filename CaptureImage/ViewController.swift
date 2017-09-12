//
//  ViewController.swift
//  CaptureImage
//
//  Created by kobe on 2017/9/12.
//  Copyright © 2017年 kobe. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ipTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ipTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    @IBAction func captureClick(_ sender: UIButton) {
        
        let url = URL(string: "http://az616578.vo.msecnd.net/files/2016/05/02/635977562108560005-679443365_kobe.jpg")
        guard let imageData = NSData(contentsOf: url!) else {
            print("error1: imageData is nil")
            return
            
        }
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = UIImage(data: (imageData as NSData) as Data)
    
    
    }
    
    
    
    
}

