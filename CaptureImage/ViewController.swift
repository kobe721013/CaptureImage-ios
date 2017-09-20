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
    
    let waitingDialog = UIAlertController(title: "Capture", message: "Please wait...", preferredStyle: .alert)
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
    
    func showAlertDialog(titleMsg titlemsg:String, bodyMsg bodymsg:String){
        waitingDialog.dismiss(animated: false, completion: nil)
        let ac = UIAlertController(title: titlemsg, message: bodymsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showCapturingDialog(){
        
        present(waitingDialog, animated: true)
        
        
    }
    @IBAction func captureClick(_ sender: UIButton) {
        
        //let url = URL(string: "http://az616578.vo.msecnd.net/files/2016/05/02/635977562108560005-679443365_kobe.jpg")
        
       //print("isValidIP1=\(isValidEIPAddress(testStr: "67.89.90.888"))")
        
        //print("isValidIP2=\(isValidEIPAddress(testStr: "67.89.9088.99"))")
        
        //check text not nil
        guard let ipaddress = ipTextField.text else{
            print("ip address is nil")
            return
        }
        
        //check ip format
        if(isValidEIPAddress(testStr: ipTextField.text!) == false)
        {
            showAlertDialog(titleMsg: "IP address error", bodyMsg: "Please check ip address format.")
            return
        }
        
        //get image data
        DispatchQueue.global().async {
            let url = URL(string: "http://\(ipaddress):8080/reqimg")
            DispatchQueue.main.async {
                self.showCapturingDialog()
            }
            guard let imageData = NSData(contentsOf: url!) else {
                print("error1: imageData is nil")
                DispatchQueue.main.async {
                    self.showAlertDialog(titleMsg: "Capture error", bodyMsg: "Please check server or network")
                }
                
                return
                
            }
            
            DispatchQueue.main.async {
                //show image
                self.imageView.contentMode = .scaleAspectFit
                self.imageView.image = UIImage(data: (imageData as NSData) as Data)
            }
        }
        
        /*
        let url = URL(string: "http://\(ipaddress):8080/reqimg")
        guard let imageData = NSData(contentsOf: url!) else {
            print("error1: imageData is nil")
            showAlertDialog(titleMsg: "Capture error", bodyMsg: "Please check server or network")
            return
            
        }
 
        //show image
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(data: (imageData as NSData) as Data)
 */
    }
    
    
    @IBAction func saveClick(_ sender: UIButton) {
        
        guard let saveImage = imageView.image else {
            print("get image view fail. data is nil")
            showAlertDialog(titleMsg: "Save error", bodyMsg: "No image to save.")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertDialog(titleMsg: "Save error", bodyMsg: error.localizedDescription)
        }
        else
        {
            //save success
            showAlertDialog(titleMsg: "Save success", bodyMsg: "Your image has been saved to your photos.")
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //"^\\d{1,3}(\\.(\\d{1,3}(\\.(\\d{1,3}(\\.(\\d{1,3})?)?)?)?)?)?"
    
    func isValidEIPAddress(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let ipRegEx = "^\\d{1,3}(\\.(\\d{1,3}(\\.(\\d{1,3}(\\.(\\d{1,3})?)?)?)?)?)?"
        let ipTest = NSPredicate(format:"SELF MATCHES %@", ipRegEx)
        return ipTest.evaluate(with: testStr)
    }}


