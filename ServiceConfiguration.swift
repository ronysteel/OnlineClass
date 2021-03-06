//
//  ServiceConfiguration.swift
//  Demo
//
//  Created by 刘兆娜 on 16/4/14.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import Foundation

class ServiceConfiguration {
    static let PageSize = 20
    static let isUseConfig = true
    static let serviceLocatorStore = ServiceLocatorStore()
    

    //114.80.101.27:6012/
    static let serverName3 = "192.168.31.146"
    static let port3 = 3000
    
    
    static let serverName4 = "jf.yhkamani.com"
    static let port4 = 80
    
    
    
    static var serverName: String {
        get {
            if isUseConfig {
                return (serviceLocatorStore.GetServiceLocator()!.serverName)!
            } else {
                return serverName3
            }
        }
    }
    
    static var port: Int {
        get {
            if isUseConfig {
                return Int((serviceLocatorStore.GetServiceLocator()!.port)!)
            } else {
                return port3
            }
        }
    }
    
    static var http: String {
        get {
            if isUseConfig {
                return (serviceLocatorStore.GetServiceLocator()?.http)!
            } else {
                return "http"
            }
        }
    }
    
    //App
    static var CHECK_UPGRADE : String {
        get {
            return "\(http)://\(serverName):\(port)/app/checkUpgrade"
        }
    }
    
    static var REGISTER_DEVICE : String {
        get {
            return "\(http)://\(serverName):\(port)/app/registerDevice"
        }
    }
    
    static var GET_ADS : String {
        get {
            return "\(http)://\(serverName):\(port)/app/getAds"
        }
    }
    
    static var GET_PARAMETER_INFO : String {
        get {
            return "\(http)://\(serverName):\(port)/app/getparameterinfo"
        }
    }
    
    //通知IAP成功
    static var NOTIFY_IAP_SUCCESS : String {
        get {
            return "\(http)://\(serverName):\(port)/app/notifyiap"
        }
    }

    
    //User
    static var LOGIN : String {
        get {
            return "\(http)://\(serverName):\(port)/user/login"
        }
    }
    
    static var UPDATE_TOKEN : String {
        get {
            return "\(http)://\(serverName):\(port)/user/updatetoken"
        }
    }
    
    static var LOGOUT : String {
        get {
            return "\(http)://\(serverName):\(port)/user/logout"
        }
    }
    
    static var GET_PHONE_CHECK_CODE : String {
        get {
            return "\(http)://\(serverName):\(port)/user/getPhoneCheckCode"
        }
    }
    
    static var SIGNUP : String {
        get {
            return "\(http)://\(serverName):\(port)/user/signup"
        }
    }
    
    static var GET_PASSWORD: String {
        get {
            return "\(http)://\(serverName):\(port)/user/getPassword"
        }
    }
    
    static var RESET_PASSWORD : String {
        get {
            return "\(http)://\(serverName):\(port)/user/resetPassword"
        }
    }
    
    static var GET_CLIENT_NUBMER : String {
        get {
            return "\(http)://\(serverName):\(port)/user/getClientNumber"
        }
    }
    
    static var SET_NAME : String {
        get {
            return "\(http)://\(serverName):\(port)/user/setName"
        }
    }
    
    static var SET_NICK_NAME : String {
        get {
            return "\(http)://\(serverName):\(port)/user/setnickname"
        }
    }
    
    static var SET_SEX : String {
        get {
            return "\(http)://\(serverName):\(port)/user/setSex"
        }
    }
    
    static var UPLOAD_PROFILE_IMAGE : String {
    
        get {
            return "\(http)://\(serverName):\(port)/user/uploadprofileimage"
        }
    }
    
    static var GET_PROFILE_IMAGE : String {
        get {
            return "\(http)://\(serverName):\(port)/user/getprofileimage"
        }
    }
    
    static var GET_USER_STAT_DATA : String {
        get {
            return "\(http)://\(serverName):\(port)/user/getstatdata"
        }
    }
    
    //Albums
    static var GET_ALBUMS : String {
        get {
            return "\(http)://\(serverName):\(port)/albums"
        }
    }

    
    static var GET_ALBUM_SONGS: String {
        get {
            return "\(http)://\(serverName):\(port)/album/songs"
        }
    }
    
    static var SEARCH : String {
        get {
            return "\(http)://\(serverName):\(port)/album/search"
        }
    }
    
    static var GET_HOT_SEARCH_WORDS : String {
        get {
            return "\(http)://\(serverName):\(port)/album/getHotSearchWords"
        }
    }
    
    //Songs
    static var GET_SONG_LIVE_COMMENTS: String {
        get {
            return "\(http)://\(serverName):\(port)/song/livecomments"
        }
    }
    
    static var GET_SONG_COMMENTS: String {
        get {
            return "\(http)://\(serverName):\(port)/song/comments"
        }
    }
    
    static var GET_SONG_INFO : String {
        get {
            return "\(http)://\(serverName):\(port)/song/getsonginfo"
        }
    }
    
    static var SEND_HEARTBEAT : String {
        get {
            return "\(http)://\(serverName):\(port)/song/heartbeat"
        }
    }
    
    //Comment
    static var SEND_COMMENT: String {
        get {
            return "\(http)://\(serverName):\(port)/comment/add"
        }
    }
    
    static var SEND_LIVE_COMMENT: String {
        get {
            return "\(http)://\(serverName):\(port)/comment/addLive"
        }
    }
    
    //获取直播在线人数
    static var GET_LIVE_LISTERNER_COUNT : String {
        get {
            return "\(http)://\(serverName):\(port)/song/livelistener"
        }
    }
    
    
    
    
    static let ImageUrlPrefix = "http://\(serverName):\(port)/"
    static func GetSongUrl(urlSuffix: String) -> String {
        return urlSuffix
    }
    static func GetAlbumImageUrl(urlSuffix: String) -> String {
        return urlSuffix
    }
    
    
    static var GET_SERVICE_LOACTOR_URL : String {
        get {
            //return "http://servicelocator.hengdianworld.com:9000/servicelocator"
            return "http://servicelocator.jinjunhang.com/servicelocator"
        }
    }




}
