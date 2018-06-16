//
//  UserDefaults+Subscript.swift
//  ios-userdefaults-sample
//
//  Created by ogasawara_dev on 2018/06/16.
//  Copyright © 2018年 ogasawara_dev. All rights reserved.
//

import Foundation

//第一段階：Stringをキーにした値の保存と取得
extension UserDefaults {
    subscript<T: Any>(key: String, defaultValue: T) -> T {
        get {
            let value = object(forKey: key)
            return (value as? T) ?? defaultValue
        }
        set {
            set(newValue, forKey: key)
            synchronize()
        }
    }
    subscript<T: Any>(key: String) -> T? {
        get {
            let value = object(forKey: key)
            return value as? T
        }
        set {
            guard let newValue = newValue else {
                removeObject(forKey: key)
                return
            }
            set(newValue, forKey: key)
            synchronize()
        }
    }
}
//第二段階：StringをrawValueに持つ型をキーにした値の保存と取得
//　　　　　Stringのリテラルを書かなくて済むのでtypoを防げます
protocol Keyable { var rawValue: String { get } }
extension UserDefaults {
    subscript<T: Any, U: Keyable>(key: U, defaultValue: T) -> T {
        get { return self[key.rawValue, defaultValue] }
        set { self[key.rawValue] = newValue }
    }
    subscript<T: Any, U: Keyable>(key: U) -> T? {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    func remove<T: Keyable>(key: T) {
        removeObject(forKey: key.rawValue)
    }
}
//第三段階：Int, Float, Double, String, Date, Bool, Array, Dictionary以外の型を
//        NSCodingでシリアライズ・デシリアライズしてUserDefaultsで使う
extension UserDefaults {
    func archive<T: NSCoding>(key: Keyable, value: T?) {
        if let value = value {
            self[key.rawValue] = NSKeyedArchiver.archivedData(withRootObject: value)
        } else {
            self[key.rawValue] = value
        }
    }
    func unarchive<T: NSCoding>(key: Keyable) -> T? {
        return data(forKey: key.rawValue)
            .map { NSKeyedUnarchiver.unarchiveObject(with: $0) } as? T
    }
    func unarchive<T: NSCoding>(key: Keyable, defalutValue: T) -> T {
        let value = data(forKey: key.rawValue)
            .map { NSKeyedUnarchiver.unarchiveObject(with: $0) } as? T
        return value ?? defalutValue
    }
}
