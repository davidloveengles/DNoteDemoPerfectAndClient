//
//  CreateContentViewController.swift
//  DNote
//
//  Created by David on 2017/5/19.
//  Copyright © 2017年 com.david. All rights reserved.
//

import UIKit

class CreateContentViewController: UIViewController {

    var contentModel: ContentModel?  {
        didSet {
            self.isUpdate = true
        }
    }
    
    var isUpdate: Bool = false
    
    @IBOutlet var contentView: UITextView!
    @IBOutlet var titleField: UITextField!
    
    @IBAction func finishAction(_ sender: Any) {
        
        guard let title = titleField.text, let content = contentView.text else {
            print("标题/内容不能为空")
            return
        }
        
        let request: URLRequest
        let userId = AppUser.shared.currentUser?.userId ?? 0
        if self.isUpdate {
            let contentId = contentModel?.id.description ?? ""
            var string = "http://localhost:8880/api/content/update?title=\(title)&content=\(content)&contentId=\(contentId)"
            string = string.addingPercentEscapes(using: String.Encoding.utf8)!
            request = URLRequest(url: URL(string: string)!)
        }else{
            var string = "http://localhost:8880/api/content/create?title=\(title)&content=\(content)&userId=\(userId)"
            string = string.addingPercentEscapes(using: String.Encoding.utf8)!
            let url = URL(string: string)!
            request = URLRequest(url: url)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard  error == nil, let data = data else{
                return
            }
            
            if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)) as? [String: Any] {
                
                if let m_resp = Mapper<BaseRespModel>().map(JSON: json), m_resp.status == 1 {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }.resume()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        titleField.text = contentModel?.title
        contentView.text = contentModel?.content
    }

}
