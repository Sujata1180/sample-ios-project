//
//  DetailDataController.swift
//  sample-ios-project
//
//  Created by Rahmat Hidayat on 7/16/18.
//  Copyright © 2018 Rahmat Hidayat. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailDataController: UIViewController {

    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var dataJson: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.imgAva.layer.cornerRadius = self.imgAva.frame.height / 2
        
        self.imgAva.loadImageUsingCacheWithUrlString(self.dataJson["avatar"].stringValue)
        self.lblName.text = "\(self.dataJson["first_name"].stringValue) \(self.dataJson["last_name"].stringValue)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnEditTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showEditData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditData" {
            let conn = segue.destination as! EditDataController
            conn.dataJson = self.dataJson
            conn.kind = 2 //For Edit
        }
    }
    
}
