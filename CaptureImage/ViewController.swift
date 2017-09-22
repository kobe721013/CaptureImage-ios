//
//  ViewController.swift
//  CaptureImage
//
//  Created by kobe on 2017/9/12.
//  Copyright © 2017年 kobe. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ipTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ipTextField.delegate = self
        
        //permission
        if PHPhotoLibrary.authorizationStatus() == .authorized{
            print("photo permission already authorized")
        }else{
            PHPhotoLibrary.requestAuthorization({ (status) in
                print("status=\(status)")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //for dismiss keypad ===== start
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    //for dismiss keypad ===== end
    
    func showAlertDialog(titleMsg titlemsg:String, bodyMsg bodymsg:String){
        //dismiss waiting dialog
        print("any ViewController present=[\(self.presentedViewController)]")
        if(self.presentedViewController != nil)
        {
        
            dismiss(animated: false, completion: {() in
                //self.showAlertDialog(titleMsg: titlemsg, bodyMsg: bodymsg)
                //show alert dialog
                self.presentAlertController(titleMsg: titlemsg, bodyMsg: bodymsg)
            })
        }
        else
        {
            self.presentAlertController(titleMsg: titlemsg, bodyMsg: bodymsg)
        }
        
    }
    
    func presentAlertController(titleMsg titlemsg:String, bodyMsg bodymsg:String)
    {
        let ac = UIAlertController(title: titlemsg, message: bodymsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func presentWaiting4CaptureController()
    {
        let waitingDialog = UIAlertController(title: "Capture", message: "Please wait...", preferredStyle: .alert)
        //let ac = UIAlertController(title: titlemsg, message: bodymsg, preferredStyle: .alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(waitingDialog, animated: true)
    }
    
    
    @IBAction func captureClick(_ sender: UIButton) {
        
        print("ip=[\(ipTextField.text!)]")
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
        //clear image
        imageView.image=nil
        
        //async download image
        presentWaiting4CaptureController()
        
        let url = URL(string: "http://\(ipaddress):8080/reqimg")
        downloadImageFrom(url:url!)
    }
    /*
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
     */
    func downloadImageFrom(url:URL) -> Void {
        
        let urlConfig = URLSessionConfiguration.default
        urlConfig.timeoutIntervalForRequest = 5
        urlConfig.timeoutIntervalForResource = 5

        let session = URLSession(configuration: urlConfig)
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
        
            if let e = error{
                print("error1 : \(e)")
                DispatchQueue.main.async {
                    self.showAlertDialog(titleMsg: "Capture error", bodyMsg: e.localizedDescription)
                }
            }
            else{
                if let res = response as? HTTPURLResponse{
                    print("responseCode=\(res.statusCode)")
                    if let imageData = data{
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.imageView.contentMode = .scaleAspectFit
                            self.imageView.image = image
                            self.dismiss(animated: false, completion: nil) //showCapturingDialog(yesIWantToShow: false)
                        }
                    }else{
                        print("error2")
                        DispatchQueue.main.async {
                            self.showAlertDialog(titleMsg: "Capture error", bodyMsg: "image data is nil. http code is: \(res.statusCode)")
                        }                    }
                
                }else{
                    print("error3")
                    DispatchQueue.main.async {
                        self.showAlertDialog(titleMsg: "Capture error", bodyMsg: "no response.")
                    }                }
            }
            
        })
        
        task.resume()
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        
        guard let saveImage = imageView.image else {
            print("get image view fail. data is nil")
            showAlertDialog(titleMsg: "Save error", bodyMsg: "No image to save.")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //callback for save image
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
    
   
    //check ip address format
    func isValidEIPAddress(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let ipRegEx = "^\\d{1,3}(\\.(\\d{1,3}(\\.(\\d{1,3}(\\.(\\d{1,3})?)?)?)?)?)?"
        let ipTest = NSPredicate(format:"SELF MATCHES %@", ipRegEx)
        return ipTest.evaluate(with: testStr)
    }}


