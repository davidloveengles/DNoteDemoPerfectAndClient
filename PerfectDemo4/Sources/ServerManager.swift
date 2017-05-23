//
//  ServerManager.swift
//  PerfectDemo3
//
//  Created by David on 2017/5/18.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

enum StatusCode: Int {
    case Faile = -1
    case SUCCESS = 1
}


class ServerManager {
    
    fileprivate var server = HTTPServer()
    
    init(root: String = "./webroot", port: UInt16) {
        
        server.documentRoot = root
        server.serverPort = port
        
        var routes = Routes(baseUri: "/api")
        configRoutes(routes: &routes)
        server.addRoutes(routes)
        
        server.setResponseFilters([(FilterResponse(), .high)])
    }
    
    func startServer() {
        do {
            try server.start()
        } catch PerfectError.networkError(let error, let msg) {
            print("网络出现错误: \(error) \(msg)")
        } catch {
            print("网络未知错误")
        }

    }
    
}


extension ServerManager {
    
    fileprivate func configRoutes(routes: inout Routes) {
        
        /// user
        // 增加用户
        routes.add(method: .get, uri: "/user/create") { (request, response) in
            
            var status: StatusCode = .Faile
            var msg: String = ""
            var data: Any? = nil
            defer {
                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
                response.appendBody(string: json)
                response.completed()
            }
            
            guard let username = request.param(name: "username"), let password = request.param(name: "password") else {
                msg = "username 或 password 为空"
                return
            }
            
            // 查找有没有该用户
            if let user = UserTableOperator.shared.queryUserInfo(username: username) {
                do {
                    try UserTableOperator.shared.insertUserInfo(username: username, passwrod: password)
                    status = .SUCCESS
                    msg = "操作成功"
                }catch {
                    msg = "操作失败"
                }
            }else {
                msg = "用户已存在"
            }
            
        }
        
        // 修改用户
//        routes.add(method: .get, uri: "/user/update") { (request, response) in
//            
//            var status: StatusCode = .Faile
//            var msg: String = ""
//            var data: Any? = nil
//            defer {
//                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
//                response.appendBody(string: json)
//                response.completed()
//            }
//            
//            if let username = request.param(name: "username"), let password = request.param(name: "password") {
//                do {
//                   try UserTableOperator.shared.updateUserInfo(username: username, passwrod: password)
//                   status = .SUCCESS
//                   msg = "操作成功"
//                }catch {
//                    msg = "操作失败"
//                }
//            }else {
//                msg = "参数不够"
//            }
//        }
        
        // 查找用户
        routes.add(method: .get, uri: "/user/query") { (request, response) in
            
            var status: StatusCode = .Faile
            var msg: String = ""
            var data: Any? = nil
            defer {
                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
                response.appendBody(string: json)
                response.completed()
            }
            
            if let username = request.param(name: "username") {
                
                if let user = UserTableOperator.shared.queryUserInfo(username: username) {
                    status = .SUCCESS
                    msg = "操作成功"
                    data = try? user.asDataDict().jsonEncodedString()
                }else {
                    msg = "操作失败"
                }
            }else {
                msg = "参数不够"
            }
        }
        
        // 登陆
        routes.add(method: .get, uri: "/user/login") { (request, response) in
            
            var status: StatusCode = .Faile
            var msg: String = ""
            var data: Any? = nil
            defer {
                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
                response.appendBody(string: json)
                response.completed()
            }
            
            if let username = request.param(name: "username"), let password = request.param(name: "password") {
                
                if let user = UserTableOperator.shared.queryUserInfo(username: username, password: password) {
                    status = .SUCCESS
                    msg = "操作成功"
                    data = try? user.asDataDict().jsonEncodedString()
                }else {
                    msg = "操作失败"
                }
                
            }else {
                 msg = "userId为空"
            }
            
        }
        
        /// content
        // 查找用户content
        routes.add(method: .get, uri: "/content/query") { (request, response) in
            
            var status: StatusCode = .Faile
            var msg: String = ""
            var data: Any? = nil
            defer {
                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
                response.appendBody(string: json)
                response.completed()
            }
            
            if let userId = request.param(name: "userId") {
                
                if let contents = ContentTableOperator.shared.queryUserContent(userId: userId) {
                    status = .SUCCESS
                    msg = "操作成功"
                    data = try? contents.rowsJsonString()
                }else {
                    msg = "操作失败"
                }
            }else {
                msg = "userId为空"
            }
            
        }

        // 增加用户content
        routes.add(method: .get, uri: "/content/create") { (request, response) in
            
            var status: StatusCode = .Faile
            var msg: String = ""
            var data: Any? = nil
            defer {
                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
                response.appendBody(string: json)
                response.completed()
            }
            
            guard let title = request.param(name: "title"), let content = request.param(name: "content"), let userId = request.param(name: "userId")  else {
                msg = "title 或 content 或 userId 为空"
                return
            }
            
            do {
                try ContentTableOperator.shared.insertSql(title: title, content: content, userId: userId)
                status = .SUCCESS
                msg = "操作成功"
            }catch {
                msg = "操作失败"
            }
            
        }

        // 修改用户content
        routes.add(method: .get, uri: "/content/update") { (request, response) in
            
            var status: StatusCode = .Faile
            var msg: String = ""
            var data: Any? = nil
            defer {
                let json = self.baseResponseJsonData(status: status, msg: msg, data: data)
                response.appendBody(string: json)
                response.completed()
            }
            
            if let title = request.param(name: "title"), let content = request.param(name: "content"), let contentId = request.param(name: "contentId") {
                do {
                    try ContentTableOperator.shared.updateSql(title: title, content: content, contentId: contentId)
                    status = .SUCCESS
                    msg = "操作成功"
                }catch {
                    msg = "操作失败"
                }
            }else {
                msg = "参数不够"
            }
            
        }
    }
}


extension ServerManager {
    
    /// 通用响应格式
    fileprivate func baseResponseJsonData(status: StatusCode, msg: String, data: Any?) -> String {
        
        var result = [String: Any]()
        result.updateValue(status.rawValue, forKey: "status")
        result.updateValue(msg, forKey: "msg")
        if data != nil {
            result.updateValue(data!, forKey: "data")
        }else {
            result.updateValue("", forKey: "data")
        }
        
        guard let json = try? result.jsonEncodedString() else{
            return ""
        }
        
        return json
    }
    
    /// 过滤某些响应
    struct FilterResponse: HTTPResponseFilter {
        
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            switch response.status {
            case .notFound:// 过滤404
                response.setBody(string: "404")
            default:
                callback(.continue)
            }
        }
        
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
    }
}
