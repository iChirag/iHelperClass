//
//  ViewController.swift
//  iHelperClass
//
//  Created by Chirag Lukhi on 16/09/14.
//  Copyright (c) 2014 iChirag. All rights reserved.
//

import UIKit

class ViewController: UIViewController,iHelperClassDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: All buttons clicked
    @IBAction func btnCallGetws_clicked(sender: AnyObject) {
        
        var objHelper:iHelperClass=iHelperClass()
        
        ///Developer can call directly URL with query string by passing nil to parameters as below :
        
//        objHelper.iHelperAPI_GET("http://api.geonames.org/citiesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&lang=de&username=demo", parameters: nil,apiIdentifier: "get_identifier",delegate: self)
        
        //Developer can call url and parameter separately as well as follow :
        
        var dicParam:NSMutableDictionary=NSMutableDictionary()
        dicParam.setObject("44.1", forKey: "north")
        dicParam.setObject("-9.9", forKey: "south")
        dicParam.setObject("-22.4", forKey: "east")
        dicParam.setObject("55.2", forKey: "west")
        
        dicParam.setObject("de", forKey: "lang")
        dicParam.setObject("demo", forKey: "username")

        objHelper.iHelperAPI_GET("http://api.geonames.org/citiesJSON", parameters: dicParam,apiIdentifier: "get_identifier",delegate: self)
        
        
    
    }

    @IBAction func btnCallPOSTws_clicked(sender: AnyObject) {
        
        var objHelper:iHelperClass=iHelperClass()
        
        var dicParam:NSMutableDictionary=NSMutableDictionary()
        dicParam.setObject("44.1", forKey: "north")
        dicParam.setObject("-9.9", forKey: "south")
        dicParam.setObject("-22.4", forKey: "east")
        dicParam.setObject("55.2", forKey: "west")
        
        dicParam.setObject("de", forKey: "lang")
        dicParam.setObject("demo", forKey: "username")
        
        objHelper.iHelperAPI_POST("http://api.geonames.org/citiesJSON", parameters: dicParam,apiIdentifier: "post_identifier",delegate: self)
    
    }
    
    @IBAction func btnImageUploadingws_clicked(sender: AnyObject) {
        
        var dicParam:NSMutableDictionary=NSMutableDictionary()
        dicParam.setObject("ichirag", forKey: "firstname")
        
        dicParam.setObject("chirag@chirag.com", forKey: "email")
        
        dicParam.setObject("chirag123", forKey: "password")
        dicParam.setObject("ios", forKey: "device_type")
        dicParam.setObject("JKJKKJKJKJKJKJKJ", forKey: "device_token")
        dicParam.setObject("1", forKey: "gender")
        
        dicParam.setObject("register", forKey: "method")
        
        
        dicParam.setObject("1", forKey: "reg_type")
        
        dicParam.setObject("1", forKey: "latitude")
        dicParam.setObject("1", forKey: "longitude")
        dicParam.setObject("Asia/Kolkata", forKey: "timezone")
        dicParam.setObject("Surat", forKey: "location")
        
        
        var dicImgParam:NSMutableDictionary=NSMutableDictionary()
        var dataImg=UIImageJPEGRepresentation(UIImage(named:"testing.jpg"), 1)
        
        dicImgParam.setObject(dataImg, forKey: "profilephoto")//you can upload image,video,doc,xls,pdf or anyfile type of objects here as NSData object
        
        var objHelper:iHelperClass=iHelperClass()
        
        
        objHelper.iHelperAPI_FileUpload("<ANY URL>/webservice.php", parameters: dicParam, parametersImage: dicImgParam, apiIdentifier: "IMAGE", delegate: self)
        

        
    }
    
    
    @IBAction func btnCallwsAsJSON_clicked(sender: AnyObject) {
        var objHelper:iHelperClass=iHelperClass()
        

        
        var strJSON :NSString="{\"userId\" : \"13645\"}"
        
        
        objHelper.iHelperAPI_JSON("<ANY URL>", json: strJSON, apiIdentifier: "JSON", delegate: self)
    }
    
    
    // MARK: iHelperClassDelegate
    func iHelperResponseSuccess(ihelper: iHelperClass) {
        
        if(ihelper.ApiIdentifier=="get_identifier")
        {
            var stringJson = NSString(data: ihelper.responseData!, encoding: NSUTF8StringEncoding)
            
            println("wenservice GET response >>> \(stringJson)")
        }

        if(ihelper.ApiIdentifier=="post_identifier")
        {
            var stringJson = NSString(data: ihelper.responseData!, encoding: NSUTF8StringEncoding)
            
            println("wenservice POST response >>> \(stringJson)")
        }

        
        if(ihelper.ApiIdentifier=="JSON")
        {
            var stringJson = NSString(data: ihelper.responseData!, encoding: NSUTF8StringEncoding)
            
            println("json response >>>> \(stringJson)")
        }
        if(ihelper.ApiIdentifier=="IMAGE")
        {
            
            var stringJson = NSString(data: ihelper.responseData!, encoding: NSUTF8StringEncoding)
            
            println("IMAGE response >>>> \(stringJson)")
        }
    }
    
    func iHelperResponseFail(connection: NSURLConnection, error: NSError) {
        println("error : \(error)")
        
        let alert = UIAlertController(title: "Error", message: "ERROR : \(error)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
}

