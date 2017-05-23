//
//  UserTableOperator.swift
//  PerfectDemo3
//
//  Created by David on 2017/5/18.
//
//


import StORM
import MySQLStORM
import SwiftMoment
import PerfectLib

class User: MySQLStORM {
    
    var userId          : Int = 0
    var username		: String = ""
    var password		: String = ""
    var createTime		: String = moment().format()
    
    override open func table() -> String { return "User" }
    
    override func to(_ this: StORMRow) {
        if this.data["userId"] is Int32 {
            userId = Int(this.data["userId"] as? Int32 ?? 0)
        }else{
            userId				= this.data["userId"] as? Int		 ?? 0
        }
        username                = this.data["username"] as? String		 ?? ""
        password                = this.data["password"] as? String		 ?? ""
        createTime              = this.data["createTime"] as? String     ?? ""
    }
    
    func rows() -> [User] {
        var rows = [User]()
        for i in 0..<self.results.rows.count {
            let row = User()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}


class UserTableOperator: DBBaseOperator {
    
    static let shared = UserTableOperator()
    private override init() {
        try? User().setup()
    }
    
    func insertUserInfo(username: String, passwrod: String) throws {

        let user = User()
        user.username = username
        user.password = passwrod
        
        do {
            try user.save()
        }catch {
            throw error
        }
    }
    
    func deleteUserInfo(userId: String) throws  {
        
        let user = User()
        user.userId = Int(userId) ?? 0
        do {
            try user.delete(userId)
        }catch {
            throw error
        }
    }
    
    func updateUserInfo(username: String, passwrod: String) throws {
        
        let user = User()
        user.username = username
        user.password = passwrod
        do {
            try user.find(["username":username, "password": passwrod])
            try user.update(cols: ["username","password"], params: [username, passwrod], idName: "userId", idValue: user.userId)
        }catch {
            throw error
        }
        
    }
    
    func queryUserInfo(username: String) -> User? {
        
        let user = User()
        user.username = username
        
        do {
            try user.find(["username": username])
        }catch {
            return nil
        }
        
        return user.userId == 0 ? nil : user
    }
    
    func queryUserInfo(username: String, password: String) -> User? {
        
        let user = User()
        
        do {
            try user.find(["username": username, "password": password])
        }catch {
            return nil
        }
        
        return user.userId == 0 ? nil : user
    }
}


