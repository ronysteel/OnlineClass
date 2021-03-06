//
//  Service.swift
//  ContractApp
//
//  Created by 刘兆娜 on 16/2/28.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import QorumLogs


class BasicService {
    
    private func sendRequest<T: ServerResponse>(url: String,
                     method: Alamofire.Method = .POST,
                     serverRequest: ServerRequest,
                     params: [String: AnyObject]? = [String: AnyObject](),
                     hasResendForTokenInvalid: Bool = false,
                     timeout: NSTimeInterval = 5,
                     //controller中定义的处理函数
                     completion: (resp: T) -> Void) -> T {
        let serverResponse = T()
        QL1(url)
        
        let request = NSMutableURLRequest(URL: NSURL( string: url)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout
        
        do {
            request.HTTPBody = try serverRequest.getJSON().rawData()
        } catch let error {
            QL4("catchException, ex = \(error)")
            serverResponse.status = -1
            serverResponse.errorMessage = "客户端错误，解析Request出错"
            return serverResponse
        }
        
        Alamofire.request(request)
            .responseJSON { response in
                //print("---------------------------------StartRequest---------------------------------")
                //debugPrint(response)
                
                //print("----------------------------------EndRequest----------------------------------")
                
                if response.result.isFailure {
                    QL4("服务器出错了")
                    serverResponse.status = -1
                    serverResponse.errorMessage = "服务器返回出错"
                    completion(resp: serverResponse)
                    
                } else {
                    let json = response.result.value as! NSDictionary
                    QL1(json)
                    serverResponse.status = json["status"] as! Int
                    //检查status是否是因为token过期，如果是，则需要重新验证token的值, 获得token的值后，重新发送一次请求
                    if serverResponse.status == ServerResponseStatus.TokenInvalid.rawValue && !hasResendForTokenInvalid {
                        var loginUser = LoginUserStore().getLoginUser()
                        if (loginUser != nil) {
                            let updateTokenReq = UpdateTokenRequest(userName: loginUser!.userName!, password: loginUser!.password!)
                            let fatherCompletion = completion
                            let fatherUrl = url
                            let fatherRequest = serverRequest
                            self.sendRequest(ServiceConfiguration.UPDATE_TOKEN, serverRequest: updateTokenReq, hasResendForTokenInvalid: true) {
                                (updateTokenResp : UpdateTokenResponse) -> Void in
                                QL1("handle update token response")
                                if updateTokenResp.status != 0  {
                                    serverResponse.errorMessage = "登录已过期，请重新登录"
                                    fatherCompletion(resp: serverResponse)
                                    return
                                }
                                
                                //保存token
                                loginUser = LoginUserStore().getLoginUser()
                                QL1(loginUser)
                                loginUser!.token = updateTokenResp.token
                                QL1("set token")
                                if !LoginUserStore().updateLoginUser() {
                                    serverResponse.errorMessage = "登录已过期，请重新登录"
                                    fatherCompletion(resp: serverResponse)
                                    return
                                }
                                
                                //重新发送请求
                                QL1("重新发送请求")
                                QL1(fatherRequest)
                                fatherRequest.test = "resend"
                                self.sendRequest(fatherUrl, serverRequest: fatherRequest, params: fatherRequest.params, hasResendForTokenInvalid: true, completion: fatherCompletion)
                            }
                        }
                    }
                    
                    if serverResponse.status == 0 {
                        serverResponse.parseJSON(serverRequest, json: response.result.value as! NSDictionary)
                        completion(resp: serverResponse)
                    } else if serverResponse.status == ServerResponseStatus.TokenInvalid.rawValue {
                        //在上面的代理处理，推迟resp处理
                        QL1("handle invalid token")
                        if hasResendForTokenInvalid {
                            serverResponse.errorMessage = "请重新登录"
                            completion(resp: serverResponse)
                        }
                    } else  {
                        serverResponse.errorMessage = json["errorMessage"] as? String
                        completion(resp: serverResponse)
                    }
                }
        }
        
        return serverResponse
    }
    
    
    func sendRequest<T: ServerResponse>(url: String,
                     request: ServerRequest,
                     timeout: NSTimeInterval = 5,
                     method: Alamofire.Method = .POST,
                     //controller中定义的处理函数
        completion: (resp: T) -> Void) -> T {
        return sendRequest(url, method: method, serverRequest: request, params: request.params, timeout: timeout, completion: completion)
    }
    
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    func uploadImageRequest(url:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        ///////
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    

    
}


