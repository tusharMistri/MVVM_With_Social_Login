//
//  WebserviceClass.swift
//  Demo_MVVM
//
//  Created by Tushar on 28/10/19.
//  Copyright © 2019 tushar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private var shared: WebserviceClass? =  nil

class WebserviceClass: NSObject {

    class func sharedInstance() -> WebserviceClass{
        if shared == nil{
            shared = WebserviceClass()
        }
        return shared!
    }
    
    // Using Alamofire : GET Method
    
    func getApiResponse<T:Decodable>(type:T.Type, api : APIName, completionHandler : @escaping (Bool, T?) -> Void){
        
        Alamofire.request(api.value()).responseJSON { (response) in
            if response.result.value != nil{
                do{
                    let decodeEnum = try JSONDecoder().decode(T.self, from: response.data!)
                    completionHandler(true,decodeEnum)
                }catch{
                    completionHandler(false,nil)
                }
            }
        }
    }
    
    // Using Alamofire : POST Method
    
    func postApiResponse<T:Decodable>(type:T.Type, api: APIName, parameter : [String:AnyObject],completionHandler : @escaping (Bool, T?) -> Void) {
        
        Alamofire.request(api.value(), method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                if response.result.value != nil{
                    do{
                        let decodeEnum = try JSONDecoder().decode(T.self, from: response.data!)
                        completionHandler(true,decodeEnum)
                    }catch{
                        completionHandler(false,nil)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Using Alamofire - Upload Image
    
    func uploadImageWithparams(api:APIName, params:[String:String],image:UIImage! ,completionhandler: @escaping (Bool, Any)-> Void){
        
        let imgData = image.jpegData(compressionQuality: 2)
        
        if imgData == nil{
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "image",fileName: "sample.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:api.value())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value as Any)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    // Using URLSession : POST Method
    
    func postApiResponseWithParam<T:Decodable>(type:T.Type, api: APIName, parameter : [String:AnyObject],completionHandler : @escaping (Bool, T?) -> Void)
    {
        // prepare json data
//        let json: [String: Any] = ["name": "abc@fife","salary":"pistol","age":"12"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
        
        // create post request
        let url = URL(string: api.value())!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
        
            do{
                let decodeEnum = try JSONDecoder().decode(T.self, from: data)
                completionHandler(true,decodeEnum)
            }catch{
                completionHandler(false,nil)
            }
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
        }
        task.resume()
    }
    
    
    // Using URLSession : Upload Image - Form Data.
    
    func imageUpload(api : APIName, imageView: UIImage,parameter: [String:String]?, completionHandler: @escaping (_ result:NSDictionary?,_ error:Error?) -> Swift.Void)
    {
        let request = NSMutableURLRequest.init(url: URL.init(string: api.value())!)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = imageView.jpegData(compressionQuality: 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: parameter, filePathKey: "fileToUpload", imageDataKey: imageData!, boundary: boundary) as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest,completionHandler: { (data, response, error) -> Void in
            if let data = data
            {
                print("******* response = \(response!)")
                
                print(data.count)
                
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                
                let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                print("json value \(json!)")
                
                DispatchQueue.main.async {
                    completionHandler(json,error)
                }

            }
            else if let error = error {
                print(error.localizedDescription)
                completionHandler(nil,error)
                
            }
        })
        task.resume()
    }
    
    // Create Body - Upload Image in Form Data
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        var body = Data()

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
}

extension Data {
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


// List of API's

extension WebserviceClass{
    
    enum APIName {
        case getAllUsersData
        
        func value() -> String {
            switch self {
            case .getAllUsersData:
                return "https://reqres.in/api/users?page=2"
            }
        }
        
    }
}
