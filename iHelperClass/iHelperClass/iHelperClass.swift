
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
    optional func iHelperResponseFail(connection: NSURLConnection?,error: NSError)
}

public class iHelperClass: NSObject,NSURLConnectionDelegate
{
    
    public enum MethodType : Int{
        case GET = 1
        case POST = 2
        case JSON = 3
        case IMAGE = 4
    }
    
    
    let timeinterval:Int = 239
    private var objConnection:NSURLConnection?
    private var objURL:NSString!
    private var objParameter:NSMutableDictionary?
    private var objUtility:iHelperUtility!
    public  var responseData:NSData!
    var delegate:iHelperClassDelegate?
    public var ApiIdentifier:NSString!=""
    
    
    
    override init()
    {
        super.init();
        objUtility=iHelperUtility()
    }
    
    // MARK: Method Web API
    
    /// Call GET request webservice (urlMethodOrFile, parameters:,apiIdentifier,delegate)
    func iHelperAPI_GET(urlMethodOrFile:NSString, parameters:NSMutableDictionary?,apiIdentifier:NSString,delegate:iHelperClassDelegate!)
    {
        self.objParameter=parameters
        self.ApiIdentifier=apiIdentifier
        self.delegate=delegate
        
        var strParam :NSString? = objUtility!.generateParam(objParameter)
        
        if (strParam != "")
        {
          strParam = "?" + strParam!
        }
        
        var strURL:String = "\(urlMethodOrFile)" + strParam!
        self.objURL=strURL
        
        self.CallURL(nil, methodtype: MethodType.GET)
        
    }
    
    /// Call POST request webservice (urlMethodOrFile, parameters,apiIdentifier,delegate)
    func iHelperAPI_POST(urlMethodOrFile:NSString, parameters:NSMutableDictionary?,apiIdentifier:NSString,delegate:iHelperClassDelegate!)
    {
        self.objParameter=parameters
        self.ApiIdentifier=apiIdentifier
        self.delegate=delegate
        
        var strParam :NSString? = objUtility!.generateParam(objParameter!)
        var strURL:String = (urlMethodOrFile)
        self.objURL=strURL
        
        self.CallURL(strParam?.dataUsingEncoding(NSUTF8StringEncoding), methodtype: MethodType.POST);
    }
    
    /// Upload file and text data through webservice (urlMethodOrFile, parameters,parametersImage(dictionary of NSData),apiIdentifier,delegate)
    func iHelperAPI_FileUpload(urlMethodOrFile:NSString, parameters:NSMutableDictionary?,parametersImage:NSMutableDictionary?,apiIdentifier:NSString,delegate:iHelperClassDelegate!)
    {
        self.objParameter=parameters
        self.ApiIdentifier=apiIdentifier
        self.delegate=delegate
        
        
        var strParam :NSString? = objUtility!.generateParam(self.objParameter!)
        var strURL:String = (urlMethodOrFile)
        self.objURL=strURL
        
        var body : NSMutableData?=NSMutableData()
        
        
        var dicParam:NSDictionary = parameters!
        var dicImageParam:NSDictionary = parametersImage!
        
        
        var boundary:NSString? = "---------------------------14737809831466499882746641449"

        // process text parameters
        for (key, value) in dicParam {
            body?.appendData(("\r\n--\(boundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            body?.appendData(("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            body?.appendData(("\r\n--\(boundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        }

        
        //process images parameters
        var i:Int=0
        for (key, value) in dicImageParam {
            body?.appendData(("\r\n--\(boundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            body?.appendData(("Content-Disposition: file; name=\"\(key)\"; filename=\"image.png\(i)\"\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            body?.appendData(("Content-Type: application/octet-stream\r\n\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            body?.appendData(value as NSData);
            body?.appendData(("\r\n--\(boundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        }

        
        body?.appendData(("\r\n--\(boundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        
        
        self.CallURL(body!, methodtype: MethodType.IMAGE);
        
    }
    
    
    
    
    /// Call JSON webservice (urlMethodOrFile,json,apiIdentifier,delegate)
    func iHelperAPI_JSON(urlMethodOrFile:NSString, json:NSString?,apiIdentifier:NSString,delegate:iHelperClassDelegate!)
    {
        self.ApiIdentifier=apiIdentifier
        self.delegate=delegate
        
        var strParam :NSString? = json
        var strURL:String = urlMethodOrFile
        self.objURL=strURL
        
        self.CallURL(strParam?.dataUsingEncoding(NSUTF8StringEncoding),methodtype: MethodType.JSON)
        
    }

    private func CallURL(dataParam:NSData?,methodtype:MethodType)
    {
        println(self.objURL)
        
        if(!self.objUtility.isInternetAvailable())
        {
            println("INTERNET NOT AVAILABLE")
            var error :NSError=NSError(domain: "INTERNET NOT AVAILABLE", code: 404, userInfo: nil)
            delegate?.iHelperResponseFail?(nil, error: error)
            
            return;
        }
        
        var objurl = NSURL.URLWithString(self.objURL)
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:objurl)
        
       
        if(methodtype == MethodType.GET)
        {//if simple GET method -- here we are not using strParam as it concenate with url already
            
            request.timeoutInterval = NSTimeInterval(self.timeinterval)
            request.HTTPMethod = "GET";
        }
        
        if(methodtype == MethodType.POST)
        {//if simple POST method
            
//            request.addValue("\(strParam?.length)", forHTTPHeaderField: "Content-length")
            request.timeoutInterval = NSTimeInterval(self.timeinterval)
            request.HTTPMethod = "POST";
            request.HTTPBody=dataParam
            
            
        }
      
        if(methodtype == MethodType.JSON)
        {//if JSON type webservice called
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
//            request.addValue("\(strParam?.length)", forHTTPHeaderField: "Content-length")
            request.timeoutInterval = NSTimeInterval(self.timeinterval)
            request.HTTPMethod = "POST";
            request.HTTPBody=dataParam
        }
        
        if(methodtype == MethodType.IMAGE)
        {//if webservice with Image Uploading
            
            var boundary:NSString? = "---------------------------14737809831466499882746641449"
            var contentType:NSString? = "multipart/form-data; boundary=\(boundary)"
            
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            request.timeoutInterval = NSTimeInterval(self.timeinterval)
            request.HTTPMethod = "POST";
            request.HTTPBody=dataParam
            
        }
        
        self.objConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        self.responseData=NSData()

    }
    
    // MARK: NSURLConnection
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    {
        println("response")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        self.responseData=data
    }
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
//        println("json : \(NSString(data: self.responseData!, encoding: NSUTF8StringEncoding))")
        delegate?.iHelperResponseSuccess(self)
    }
    
    public func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        println("error iHelperClass: \(error)");
        
        delegate?.iHelperResponseFail?(connection, error: error)
    }
    
    
}


