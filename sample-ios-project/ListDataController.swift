//
//  ListDataController.swift
//  sample-ios-project
//
//  Created by Rahmat Hidayat on 7/16/18.
//  Copyright © 2018 Rahmat Hidayat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListDataController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbData: UITableView!
    
    var dataJson: JSON!
    var dataJsonSelected: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbData.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = false
        
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getData(){
        let url = "\(Helper.baseUrl)users"
        Alamofire.request(url, method: .get)
            .responseJSON{response in
                if let value = response.result.value {
                    if response.response!.statusCode == 200 {
                        self.dataJson = JSON(value)["data"]
                        self.tbData.delegate = self
                        self.tbData.dataSource = self
                        self.tbData.reloadData()
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! ListDataCell
        
        cell.accessoryType = .disclosureIndicator
        cell.imgAva.layer.cornerRadius = cell.imgAva.frame.height / 2
        
        let data = self.dataJson[indexPath.row]
        cell.imgAva.loadImageUsingCacheWithUrlString(data["avatar"].stringValue)
        cell.lblName.text = "\(data["first_name"].stringValue) \(data["last_name"].stringValue)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataJsonSelected = self.dataJson[indexPath.row]
        self.performSegue(withIdentifier: "showDetailData", sender: self)
    }
    
    @IBAction func btnAddDataTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showAddData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailData" {
            let conn = segue.destination as! DetailDataController
            conn.dataJson = self.dataJsonSelected
        }
        if segue.identifier == "showAddData" {
            let conn = segue.destination as! EditDataController
            conn.kind = 1 //For Add
        }
    }
    
    @IBAction func backToListMembers(_ sender: UIStoryboardSegue){}
}
