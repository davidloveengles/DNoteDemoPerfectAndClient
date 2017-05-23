//
//  ContentModle.swift
//  DNote
//
//  Created by David on 2017/5/19.
//  Copyright © 2017年 com.david. All rights reserved.
//

import Foundation


class AppUser {
    
    static let shared = AppUser()
    private init() {}
    
    var currentUser: UserModel?
}

struct UserModel: Mappable {
    
    var username: String?
    var userId: Int?
    var password: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        username <- map["username"]
        userId <- map["userId"]
        password <- map["password"]
    }
}




struct BaseRespModel: Mappable {

    var status: Int?
    var msg: String = ""
    var data: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
    
    
}

struct ContentModel: Mappable {
    
    var id: Int!
    var title: String = ""
    var content: String = ""
    var createTime = ""
    var userId: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
//        id <- (map["id"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        createTime <- map["createTime"]
//        userId <- (map["userId"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        userId <- map["userId"]
    }

}
