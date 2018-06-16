# ios-userdefaults-sample

## feature

UserDefaults using subscript which accepts enum or so.

```swift
//  ios_userdefaults_sampleTests.swift

let expectedDate = Date()
userDefaults[.lastLaunchDate] = expectedDate
let date: Date? = userDefaults[.lastLaunchDate]
```
No typo😄

You can save any class conforming NSCoding.

```swift
       class Team: NSObject, NSCoding {
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
        print(value!.name) // "あんこう"
```

## Requirements

- Swift4
- Xcode9.3

## Reference

[Swift 4 で UserDefaults を簡単に扱う - ユニファ開発者ブログ](http://tech.unifa-e.com/entry/2018/01/09/143231)

[swift-evolution/0148-generic-subscripts.md at master · apple/swift-evolution](https://github.com/apple/swift-evolution/blob/master/proposals/0148-generic-subscripts.md)

[【iOS】UserDefaultsをSwiftらしく使う - Qiita](https://qiita.com/KokiEnomoto/items/c79c7f3793a244246fcf)