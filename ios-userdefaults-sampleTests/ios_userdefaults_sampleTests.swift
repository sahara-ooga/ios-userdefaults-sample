//
//  ios_userdefaults_sampleTests.swift
//  ios-userdefaults-sampleTests
//
//  Created by ogasawara_dev on 2018/06/16.
//  Copyright © 2018年 ogasawara_dev. All rights reserved.
//
import Foundation
import XCTest
@testable import ios_userdefaults_sample

class ios_userdefaults_sampleTests: XCTestCase {
    let userDefaults = UserDefaults.standard

    func testDate() {
        let expectedDate = Date()
        userDefaults[.lastLaunchDate] = expectedDate
        let date: Date? = userDefaults[.lastLaunchDate]
        XCTAssertEqual(date, expectedDate)
    }
    func testBool() {
        userDefaults[.isEverLaunched] = true
        let bool: Bool? = userDefaults[.isEverLaunched]
        XCTAssertEqual(bool, true)
    }
    func testRemove() {
        userDefaults[.isEverLaunched] = true
        userDefaults.remove(key: .isEverLaunched)
        XCTAssertNil(userDefaults[.isEverLaunched])
    }
}
extension ios_userdefaults_sampleTests {
    //ユーザー定義型の保存
    func testCustomClass() {
    @objc(_TtCFC28ios_userdefaults_sampleTests28ios_userdefaults_sampleTests15testCustomClassFT_T_L_4Team)class Team: NSObject, NSCoding {
            var name = String()
            
            override init() {}
            
            required init?(coder aDecoder: NSCoder) {
                name = aDecoder.decodeObject(forKey: "name") as! String
            }
            
            func encode(with aCoder: NSCoder) {
                aCoder.encode(name, forKey: "name")
            }
        }
        let team = Team()
        let teamName = "あんこう"
        team.name = teamName
        let userDefaults = UserDefaults.standard
        userDefaults.archive(key: "team", value: team)
        let value: Team? = userDefaults.unarchive(key: "team")
        XCTAssertEqual(value?.name, teamName)
    }
}
//UserDefaultsのキーを定義して、区分値をsubscriptに与えればアクセスできるようにする（型名を省略）
enum AppKey: String, Keyable {
    case lastLaunchDate
    case isEverLaunched
}
extension UserDefaults {
    subscript<T: Any>(key: AppKey, defaultValue: T) -> T {
        get { return self[key.rawValue, defaultValue] }
        set { self[key.rawValue] = newValue }
    }
    subscript<T: Any>(key: AppKey) -> T? {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    func remove(key: AppKey) {
        removeObject(forKey: key.rawValue)
    }
}
extension String: Keyable {
    public var rawValue: String { return self }
}
