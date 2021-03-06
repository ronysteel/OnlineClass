//
//  Model.swift
//  Demo
//
//  Created by 刘兆娜 on 16/4/14.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import Foundation


class BaseModelObject : NSObject {
    
}

class CourseType: BaseModelObject {
    //case Common, Vip, Live
    static let LiveCourse = CourseType(name: "直播课程", code: "Live")
    static let PayCourse = CourseType(name: "会员专享课程", code: "Vip")
    var name : String
    var code : String
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    var isLive : Bool {
        return true
    }
    
    static func getCourseType(code: String) -> CourseType? {
        if code ==  LiveCourse.code {
            return LiveCourse
        } else if code == PayCourse.code {
            return PayCourse
        }
        return nil
    }
}


class Album : BaseModelObject {
    var id: String = ""
    var name: String = ""
    var desc: String = ""
    var author: String = ""
    var image: String = ""
    var count: Int = 0
    var listenCount : String = ""
    var courseType = CourseType.LiveCourse
    var playing : Bool = false
    var isReady : Bool = false
    var songs = [Song]()
    
    var hasImage: Bool {
        get {
            return !image.isEmpty
        }
    }
    
    override var description: String {
        get {
            return "{'id': \(id)}"
        }
    }
    
    var isLive: Bool {
        return courseType.isLive
    }
}

class SongSetting : BaseModelObject {
    var maxCommentWord: Int = 30
    var canComment: Bool = true
}

class Advertise : BaseModelObject {
    var imageUrl = ""
    var clickUrl = ""
    var title = ""
}

class Song : BaseModelObject {
    var id: String = ""
    var name: String = ""
    var desc: String = ""
    var date: String = ""
    var url: String = ""
    var imageUrl: String = ""
    var settings = SongSetting()
    var album: Album!
    var wholeUrl : String {
        return ServiceConfiguration.GetSongUrl(url)
    }
    var isLive : Bool {
        return album.isLive
    }

    override var description: String {
        get {
            return "{'id': \(id)}"
        }
    }
    
}

class LiveSong : Song {
    let dateFormatter = NSDateFormatter()
    let dateFormatter2 = NSDateFormatter()
    override init() {
        super.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter2.dateFormat = "yyyy-MM-dd"
    }
    
    var startDateTime: String?
    var listenPeople: String = ""
    
    
    var startTime: String? {
        get {
            if startDateTime == nil {
                return ""
            }
            return (startDateTime! as NSString).substringFromIndex(10)
        }
    }
    var endDateTime: String?
    var endTime: String? {
        get {
            if startDateTime == nil {
                return ""
            }
            return (endDateTime! as NSString).substringFromIndex(10)
        }
    }
    
    var totalTime: NSTimeInterval {
        if startDateTime == nil || endDateTime == nil {
            return NSTimeInterval(0)
        }
        return dateFormatter.dateFromString(endDateTime!)!.timeIntervalSinceDate(dateFormatter.dateFromString(startDateTime!)!)
    }
    
    var leftTime : NSTimeInterval {
        get {
            if startDateTime == nil || endDateTime == nil {
                return NSTimeInterval(0)
            }
            return dateFormatter.dateFromString(endDateTime!)!.timeIntervalSinceNow
        }
    }
    
    var playedTime : NSTimeInterval {
        get {
            if startDateTime == nil || endDateTime == nil {
                return NSTimeInterval(0)
            }
            return totalTime - leftTime

        }
    }
    
    var progress : Float {
        get {
            return Float( (self.totalTime - self.leftTime) / self.totalTime )
        }
    }
    
    var hasAdvImage : Bool!
    var advImageUrl: String?
    var advUrl: String?
    var advScrollRate = 5
    var scrollAds = [Advertise]()
    
    var advText = ""
    
}

class Comment : BaseModelObject {
    var id: String?
    var song: Song?
    var userId: String!
    var nickName: String!
    var time: String!
    var content: String!
    var isManager = false
    
}

class User : BaseModelObject{
    var userName: String!
    var name: String = ""
    override var description: String {
        get {
            return "{'userName': \(userName)}"
        }
    }
}

class ChatSetting : BaseModelObject {
    var maxWordSize : Int = 50
    var canComment: Bool = true
    var lastCommenTime : NSDate?
    
}

class ServiceLocator {
    var http: String!
    var serverName: String!
    var port: Int!
    var isUseServiceLocator: String!
    
    init() {
        
    }
    
    var needServieLocator : Bool {
        get {
            if isUseServiceLocator == nil {
                return true
            }
            
            return "1" == isUseServiceLocator
        }
    }

    
}

class PurchaseRecord {
    var userid: String! //mobile
    var productId: String!
    var isNotify: Bool = false
    var payTime: String!
}