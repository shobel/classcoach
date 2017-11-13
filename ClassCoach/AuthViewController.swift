//
//  AuthViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 11/4/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {
    
    private var disappeared = false
    override func viewDidLoad() {
        super.viewDidLoad()
        DataHolder.sharedInstance.loadData()
        
        if (DataHolder.sharedInstance.authOnStart) {
            authenticate()
        } else {
            performSegue(withIdentifier: "showClassList", sender: self)
        }
        //background image
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "main_background.jpg")!)
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.navigationController?.isNavigationBarHidden = true
        if (UserDefaults.standard.bool(forKey: "authOnActive") == true && disappeared) {
            authenticate()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        disappeared = true
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    private func authenticate(){
        //step 1
        let authenticationContext = LAContext()
        
        var error:NSError?
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "Authenticate to access data in Class Coach",
            reply: { (success, error) -> Void in
                if( success ) {
                    DispatchQueue.main.async() { () -> Void in
                        self.navigationController?.isNavigationBarHidden = false
                        let numVCs = self.navigationController!.viewControllers.count
                        if (numVCs > 1){
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.performSegue(withIdentifier: "showClassList", sender: self)
                        }
                    }
                }else {
                    // Check if there is an error
                    if error != nil {
                        
                    }
                }
        })
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        showAlertWithTitle(title: "Error", message: "It is recommended that you enable device authentication to safeguard senstive data.")
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async() { () -> Void in
                self.performSegue(withIdentifier: "showClassList", sender: self)
            }
        })
        alertVC.addAction(okAction)
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func authenticateButtonAction(_ sender: Any) {
        authenticate()
    }
    
}
