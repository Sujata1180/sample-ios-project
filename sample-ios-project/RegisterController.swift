//
//  RegisterController.swift
//  sample-ios-project
//
//  Created by Rahmat Hidayat on 7/16/18.
//  Copyright © 2018 Rahmat Hidayat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnRegister.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
        self.btnRegister.loadingIndicator(true)
        if self.txtConfirmPassword.text! != self.txtPassword.text! {
            self.showAlert("Confirm Password Not Match")
        }else{
            self.register()
        }
    }
    
    func register(){
        let url = "\(Helper.baseUrl)register"
        let params = [
            "email" : self.txtEmail.text!,
            "password" : self.txtPassword.text!
        ]
        let heads = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        print(url, params, heads)
        Alamofire.request(url, method: .post, parameters: params, headers: heads)
            .responseJSON{response in
                if let value = response.result.value {
                    let data = JSON(value)
                    if response.response!.statusCode == 201 {
                        self.btnRegister.loadingIndicator(false)
                        self.performSegue(withIdentifier: "showHome", sender: self)
                    }else{
                        if let err = data["error"].string {
                            self.showAlert(err)
                        }
                    }
                }else{
                    self.showAlert(Helper.msgSalahServer)
                }
        }
    }
    
    func showAlert(_ msg: String){
        let alert = UIAlertController(title: "Oops", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.btnRegister.loadingIndicator(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
