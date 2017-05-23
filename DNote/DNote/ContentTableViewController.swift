//
//  ContentTableViewController.swift
//  DNote
//
//  Created by David on 2017/5/18.
//  Copyright © 2017年 com.david. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController {

    
    @IBAction func refreshAction(_ sender: Any) {
        loadContents()
    }
    @IBAction func addAction(_ sender: Any) {
        
    }
    
    
    
    var conents = [ContentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        
        loadContents()
    }


}

extension ContentTableViewController {
    
    func loadContents(){
        
        let request = URLRequest(url: URL(string: "http://localhost:8880/api/content/query?userId=\(AppUser.shared.currentUser?.userId ?? 0)")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard  error == nil, let data = data else{
                return
            }
            
            if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)) as? [String: Any] {
                
                if let m_resp = Mapper<BaseRespModel>().map(JSON: json), let m_contents = Mapper<ContentModel>().mapArray(JSONString: m_resp.data) {
                    
                    self.conents.removeAll()
                    self.conents.append(contentsOf: m_contents)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            }.resume()
    }
    
}

extension ContentTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let content = self.conents[indexPath.row]
        
        cell.imageView?.image = #imageLiteral(resourceName: "Picture")
        cell.textLabel?.text = content.title
        cell.detailTextLabel?.text = content.createTime
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = self.conents[indexPath.row]
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateContentViewController") as! CreateContentViewController
        vc.contentModel = content
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
