//
//  ProfileController.swift
//  sample-ios-project
//
//  Created by Rahmat Hidayat on 7/16/18.
//  Copyright © 2018 Rahmat Hidayat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileController: UIViewController {

    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgAva.layer.cornerRadius = self.imgAva.frame.height / 2
        self.btnLogout.layer.cornerRadius = 4
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData(){
        let url = "\(Helper.baseUrl)users/6"
        Alamofire.request(url, method: .get)
            .responseJSON{response in
                if let value = response.result.value {
                    let dataJson = JSON(value)
                    if response.response!.statusCode == 200 {
                        let dataMember = dataJson["data"]
                        self.imgAva.loadImageUsingCacheWithUrlString(dataMember["avatar"].stringValue)
                        self.lblName.text = dataMember["first_name"].stringValue + " " + dataMember["last_name"].stringValue
                    }
                }
        }
    }
    
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showLogin") as! LoginController
        self.present(login, animated: true, completion: nil)
    }
    
}
