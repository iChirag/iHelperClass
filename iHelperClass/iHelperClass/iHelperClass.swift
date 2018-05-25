
//
//  iHelperClass.swift
//  iHelperClass
//
//  Created by Chirag Lukhi on 12/09/14.
//  Copyright (c) 2014 iChirag. All rights reserved.
//

/*
Developer can use this class to call all type of webservice with GET and POST request.

Developer can call request as querystring parameter as well as json parameter.

Developer can use this class to upload any file type of objects(NSData) like image,video,doc,xls,pdf etc.

Developer can use this class to upload any file as well as passed string data Parallel.

Just implemenet this class delegate method in your controlloer,you will get it response in whatever format.
This iHelperClass can fetch JSON, XML or HTML (as string in case of any error occured on server side)


Please do not try to change code.

All rights are reserved under license.
*/






import Foundation


@objc protocol iHelperClassDelegate
{
    /// This will return response from webservice if request successfully done to server
    func iHelperResponseSuccess(ihelper:iHelperClass)
    
    /// This is for Fail request or server give any error
    @objc optional func iHelperResponseFail(error: NSError)
}

public class iHelperClass: NSObject,NSURLConnectionDelegate
{
    
    public enum MethodType : Int{
        case GET  =  1
        case POST  =  2
        case JSON  =  3
        case IMAGE  =  4
    }
    
    
    let timeinterval:Int  =  239
    private var objConnection:NSURLConnection?
    private var objURL:String  =  ""
    private var objParameter:NSMutableDictionary?
    private var objUtility:iHelperUtility!
    public  var responseData:NSData!
    var delegate:iHelperClassDelegate?
    public var apiIdentifier:String  =  ""
    
    
    
    override init()
    {
        super.init();
        objUtility = iHelperUtility()
    }
    
    // MARK: Method Web API
    
    /// Call GET request webservice (urlMethodOrFile, parameters:,apiIdentifier,delegate)
    func iHelperAPI_GET(urlMethodOrFile:String, parameters:NSMutableDictionary?, apiIdentifier:String, delegate:iHelperClassDelegate!) {
        self.objParameter = parameters
        self.apiIdentifier = apiIdentifier
        self.delegate = delegate
        
        var strParam :String?  =  objUtility!.generateParam(dicParam: objParameter)!
        if (strParam !=  "") {
          strParam  =  "?" + strParam!
        }
        
        objURL  =  String(format:"\(urlMethodOrFile)\(strParam!)")
        self.CallURL(dataParam: nil, methodtype: MethodType.GET)
    }
    
    /// Call POST request webservice (urlMethodOrFile, parameters,apiIdentifier,delegate)
    func iHelperAPI_POST(urlMethodOrFile:String, parameters:NSMutableDictionary?,apiIdentifier:String,delegate:iHelperClassDelegate!)
    {
        self.objParameter = parameters
        self.apiIdentifier = apiIdentifier
        self.delegate = delegate
        
        let strParam :String?  =  objUtility!.generateParam(dicParam: objParameter!)
        let strURL:String  =  (urlMethodOrFile)
        objURL = strURL
        
        self.CallURL(dataParam: strParam?.data(using: String.Encoding.utf8)! as NSData?, methodtype: MethodType.POST);
    }
    
    /// Upload file and text data through webservice (urlMethodOrFile, parameters,parametersImage(dictionary of NSData),apiIdentifier,delegate)
    func iHelperAPI_FileUpload(urlMethodOrFile:String, parameters:NSMutableDictionary?,parametersImage:NSMutableDictionary?,apiIdentifier:String,delegate:iHelperClassDelegate!)
    {
        self.objParameter = parameters
        self.apiIdentifier = apiIdentifier
        self.delegate = delegate
        
        
        var _ :String?  =  objUtility!.generateParam(dicParam: self.objParameter!)
        let strURL:String  =  (urlMethodOrFile)
        objURL = strURL
        
        let body : NSMutableData? = NSMutableData()
        
        
        let dicParam:NSDictionary  =  parameters!
        let dicImageParam:NSDictionary  =  parametersImage!
        
        
        let boundary:String?  =  "---------------------------14737809831466499882746641449"

        // process text parameters
        for (key, value) in dicParam {
            body?.append(("\r\n--\(String(describing: boundary))\r\n" as String).data(using: String.Encoding.utf8)!);
            body?.append(("Content-Disposition: form-data; name = \"\(key)\"\r\n\r\n\(value)" as String).data(using: String.Encoding.utf8)!);
            body?.append(("\r\n--\(String(describing: boundary))\r\n" as String).data(using: String.Encoding.utf8)!);
        }

        
        //process images parameters
        let i:Int = 0
        for (key, value) in dicImageParam {
            body?.append(("\r\n--\(String(describing: boundary))\r\n" as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!);
            body?.append(("Content-Disposition: file; name = \"\(key)\"; filename = \"image.png\(i)\"\r\n" as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!);
            body?.append(("Content-Type: application/octet-stream\r\n\r\n" as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!);
            body?.append((value as! NSData) as Data);
            body?.append(("\r\n--\(String(describing: boundary))\r\n" as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!);
        }

        
        body?.append(("\r\n--\(String(describing: boundary))\r\n" as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!);
        
        
        self.CallURL(dataParam: body!, methodtype: MethodType.IMAGE);
        
    }
    
    
    
    
    /// Call JSON webservice (urlMethodOrFile,json,apiIdentifier,delegate)
    func iHelperAPI_JSON(urlMethodOrFile:String, json:String?,apiIdentifier:String,delegate:iHelperClassDelegate!)
    {
        self.apiIdentifier = apiIdentifier
        self.delegate = delegate
        
        let strParam :String?  =  json
        let strURL:String  =  urlMethodOrFile as String
        objURL = strURL as String
        
        self.CallURL(dataParam: strParam?.data(using: String.Encoding.utf8)! as NSData?, methodtype: MethodType.JSON)
        
    }

    private func CallURL(dataParam:NSData?, methodtype:MethodType)
    {
        print(objURL)
        
        if(!self.objUtility.isInternetAvailable())
        {
            print("INTERNET NOT AVAILABLE")
            let error :NSError = NSError(domain: "INTERNET NOT AVAILABLE", code: 404, userInfo: nil)
            delegate?.iHelperResponseFail?(error: error)
            
            return;
        }
        
        let url  =  URL(string: objURL) // NSURL(string: objURL as String)
        var request: URLRequest  =  URLRequest(url:url! as URL)
        
       
        if(methodtype  ==  MethodType.GET)
        {//if simple GET method -- here we are not using strParam as it concenate with url already
            
            request.timeoutInterval  =  TimeInterval(self.timeinterval)
            request.httpMethod  =  "GET";
        }
        
        if(methodtype  ==  MethodType.POST)
        {//if simple POST method
            
//            request.addValue("\(strParam?.length)", forHTTPHeaderField: "Content-length")
            request.timeoutInterval  =  TimeInterval(self.timeinterval)
            request.httpMethod  =  "POST";
            request.httpBody  =  dataParam! as Data
            
            
        }
      
        if(methodtype  ==  MethodType.JSON)
        {//if JSON type webservice called
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
//            request.addValue("\(strParam?.length)", forHTTPHeaderField: "Content-length")
            request.timeoutInterval  =  TimeInterval(self.timeinterval)
            request.httpMethod  =  "POST";
            request.httpBody = dataParam! as Data
        }
        
        if(methodtype  ==  MethodType.IMAGE)
        {//if webservice with Image Uploading
            
            let boundary:String?  =  "---------------------------14737809831466499882746641449"
            let contentType:String?  =  "multipart/form-data; boundary = \(String(describing: boundary))" as String
            
            request.addValue(contentType! as String, forHTTPHeaderField: "Content-Type")
            
            request.timeoutInterval  =  TimeInterval(self.timeinterval)
            request.httpMethod  =  "POST";
            request.httpBody = dataParam! as Data
            
        }
        
//        self.objConnection  =  NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)
//        self.responseData = NSData()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                self.delegate?.iHelperResponseFail?(error: error! as NSError)

                return
            }
            // make sure we got data
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            
            self.responseData = data! as NSData
            self.delegate?.iHelperResponseSuccess(ihelper: self)
            
        }
        task.resume()
        
       

    }
    
    // MARK: NSURLConnection
    private func connection(connection: NSURLConnection, didReceiveResponse response: URLResponse)
    {
        print("response")
    }
    
    private func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        self.responseData = data
    }
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
//        println("json : \(String(data: self.responseData!, encoding: NSUTF8StringEncoding))")
        delegate?.iHelperResponseSuccess(ihelper: self)
    }
    
    public func connection(_ connection: NSURLConnection, didFailWithError error: Error)
    {
        print("error iHelperClass: \(error)");
        
        delegate?.iHelperResponseFail?(error: error as NSError)
    }
    
    
}


