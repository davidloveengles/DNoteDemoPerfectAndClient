//
//  MySQLConnect.swift
//  PerfectDemo3
//
//  Created by David on 2017/5/18.
//
//


import StORM
import MySQLStORM


struct MySQLConnect {

    static func config() {
        
        MySQLConnector.host		= "127.0.0.1"
        MySQLConnector.username	= "root"
        MySQLConnector.password	= "daixeibing:DAI2529926"
        MySQLConnector.database	= "TestDatabase2"
        MySQLConnector.port		= 3306
    }
    
}

