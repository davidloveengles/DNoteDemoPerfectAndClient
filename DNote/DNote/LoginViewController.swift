//
//  LoginViewController.swift
//  DNote
//
//  Created by David on 2017/5/18.
//  Copyright © 2017年 com.david. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func registAction(_ sender: Any) {
        regist { (success) in
            if success {
                self.tipLabel.text = "注册成功,请点击登录"
            }else {
                self.tipLabel.text = "注册失败，请从新登陆"
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let username = usernameField.text else {
            return
        }
        guard username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count > 0 else {
            return
        }
        
        login { (loginSuccess) in
            
            if loginSuccess {
                
                self.push()
            } else {
                self.tipLabel.text = "用户不存在，注册一下"
            }
        }
    }
    
    private func push() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContentTableViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

fileprivate extension LoginViewController {
    
    func regist(result: @escaping (Bool) -> ()){
        
        let request = URLRequest(url: URL(string: "http://localhost:8880/api/user/create?username=\(usernameField.text!)&password=123")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard  error == nil, let data = data else{
                    result(false)
                    return
                }
                
                if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)) as? [String: Any] {
                    
                    if let m_resp = Mapper<BaseRespModel>().map(JSON: json) {
                        if m_resp.status! == 1 {
                            result(true)
                            return
                        }
                    }
                }
                
                result(false)
            }
            
        }.resume()
    }
    
    func login(result: @escaping (Bool) -> ()) {
        let request = URLRequest(url: URL(string: "http://localhost:8880/api/user/login?username=\(usernameField.text!)&password=123")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard  error == nil, let data = data else{
                    result(false)
                    return
                }
                
                if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)) as? [String: Any] {
                    
//                    if let m_resp = Mapper<BaseRespModel>().map(JSON: json), let m_users = Mapper<UserModel>().mapArray(JSONString: m_resp.data) {
//                        
//                        if m_users.count > 0 {
//                            AppUser.shared.currentUser = m_users.first
//                            result(true)
//                            return
//                        }
//                    }
                    
                    if let m_resp = Mapper<BaseRespModel>().map(JSON: json), let m_user = Mapper<UserModel>().map(JSONString: m_resp.data){
                        
                            AppUser.shared.currentUser = m_user
                            result(true)
                            return
                    }
                    
                }
                
                result(false)
            }
        }.resume()
    }
}
