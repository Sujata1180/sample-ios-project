//
//  LoginController.swift
//  sample-ios-project
//
//  Created by Rahmat Hidayat on 7/16/18.
//  Copyright © 2018 Rahmat Hidayat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.layer.cornerRadius = 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.btnLogin.loadingIndicator(true)
        self.login()
    }
    
    func login(){
        let url = "\(Helper.baseUrl)login"
        let params = [
            "email" : self.txtEmail.text!,
            "password" : self.txtPassword.text!
        ]
        let heads = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method: .post, parameters: params, headers: heads)
            .responseJSON{response in
                if let value = response.result.value {
                    let data = JSON(value)
                    if response.response!.statusCode == 200 {
                        self.btnLogin.loadingIndicator(false)
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
            self.btnLogin.loadingIndicator(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
