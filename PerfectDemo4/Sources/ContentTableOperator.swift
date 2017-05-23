//
//  ContentTableOperator.swift
//  PerfectDemo3
//
//  Created by David on 2017/5/18.
//
//


import StORM
import MySQLStORM
import SwiftMoment

class Content: MySQLStORM {
    
    var id              : Int = 0
    var userId          : Int = 0
    var title           : String = ""
    var content         : String = ""
    var createTime		: String = moment().format()
    
    override open func table() -> String { return "Content" }
    
    override func to(_ this: StORMRow) {
        if this.data["id"] is Int32 {
            id = Int(this.data["id"] as? Int32 ?? 0)
        }else{
            id = this.data["id"] as? Int		 ?? 0
        }
        
        if this.data["userId"] is Int32 {
            userId = Int(this.data["userId"] as? Int32 ?? 0)
        }else{
            userId = this.data["id"] as? Int		 ?? 0
        }
        
        title		= this.data["title"] as? String		 ?? ""
        content		= this.data["content"] as? String		 ?? ""
        createTime			= this.data["createTime"] as? String ?? ""
    }
    
    func rows() -> [Content] {
        var rows = [Content]()
        for i in 0..<self.results.rows.count {
            let row = Content()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
 
}

// 自己添加的
extension Array where Element == Content {
    func rowsJsonString() throws -> String {
        var s = "["
        var first = true
        for v in self {
            if !first {
                s.append(",")
            } else {
                first = false
            }
            s.append(try v.asDataDict().jsonEncodedString())
        }
        s.append("]")
        return s
    }
}


class ContentTableOperator: DBBaseOperator {
    
    static let shared = ContentTableOperator()
    private override init() {
        try? Content().setup()
    }

    func insertSql(title: String, content: String, userId: String) throws {
        
        let ctent = Content()
        ctent.title = title
        ctent.content = content
        ctent.userId = Int(userId) ?? 0
        do {
            try ctent.save()
        }catch {
            throw error
        }
    }
    
    func deleteSql(contentId: String) throws {
        
        let ctent = Content()
        ctent.id = Int(contentId) ?? 0
        do {
            try ctent.delete(ctent.id)
        }catch {
            throw error
        }
    }
    
    func updateSql(title: String, content: String, contentId: String) throws {
        
        let ctent = Content()
//        ctent.title = title
//        ctent.content = content
//        ctent.id = Int(contentId) ?? 0
        do {
            try ctent.update(cols: ["title", "content"], params: [title, content], idName: "id", idValue: Int(contentId) ?? 0)
        }catch {
            throw error
        }
    }
    
    func queryUserContent(userId: String) -> [Content]? {
        
        let ctent = Content()

        do {
           try ctent.select(whereclause: "userId = ?", params: [Int(userId) ?? 0], orderby: ["id"])
        }catch {
            return nil
        }
        
        return ctent.rows()
    }
    
   
    
}
