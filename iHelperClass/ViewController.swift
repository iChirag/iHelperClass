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
        
        let objHelper:iHelperClass = iHelperClass()
        
        ///Developer can call directly URL with query string by passing nil to parameters as below :
        
//        objHelper.iHelperAPI_GET("http://api.geonames.org/citiesJSON?north = 44.1&south = -9.9&east = -22.4&west = 55.2&lang = de&username = demo", parameters: nil,apiIdentifier: "get_identifier",delegate: self)
        
        //Developer can call url and parameter separately as well as follow :
        
        let dicParam:NSMutableDictionary = NSMutableDictionary()
        dicParam.setObject("44.1", forKey: "north" as NSCopying)
        dicParam.setObject("-9.9", forKey: "south" as NSCopying)
        dicParam.setObject("-22.4", forKey: "east" as NSCopying)
        dicParam.setObject("55.2", forKey: "west" as NSCopying)
        
        dicParam.setObject("de", forKey: "lang" as NSCopying)
        dicParam.setObject("demo", forKey: "username" as NSCopying)

        objHelper.iHelperAPI_GET(urlMethodOrFile: "http://api.geonames.org/citiesJSON", parameters: dicParam,apiIdentifier: "get_identifier",delegate: self)
        
        
    
    }

    @IBAction func btnCallPOSTws_clicked(sender: AnyObject) {
        
        let objHelper:iHelperClass = iHelperClass()
        
        let dicParam:NSMutableDictionary = NSMutableDictionary()
        dicParam.setObject("44.1", forKey: "north" as NSCopying)
        dicParam.setObject("-9.9", forKey: "south" as NSCopying)
        dicParam.setObject("-22.4", forKey: "east" as NSCopying)
        dicParam.setObject("55.2", forKey: "west" as NSCopying)
        
        dicParam.setObject("de", forKey: "lang" as NSCopying)
        dicParam.setObject("demo", forKey: "username" as NSCopying)
        
        objHelper.iHelperAPI_POST(urlMethodOrFile: "http://api.geonames.org/citiesJSON", parameters: dicParam,apiIdentifier: "post_identifier",delegate: self)
    
    }
    
    @IBAction func btnImageUploadingws_clicked(sender: AnyObject) {
        
        let dicParam:NSMutableDictionary = NSMutableDictionary()
        dicParam.setObject("ichirag", forKey: "firstname" as NSCopying)
        
        dicParam.setObject("chirag@chirag.com", forKey: "email" as NSCopying)
        
        dicParam.setObject("chirag123", forKey: "password" as NSCopying)
        dicParam.setObject("ios", forKey: "device_type" as NSCopying)
        dicParam.setObject("JKJKKJKJKJKJKJKJ", forKey: "device_token" as NSCopying)
        dicParam.setObject("1", forKey: "gender" as NSCopying)
        dicParam.setObject("register", forKey: "method" as NSCopying)
        dicParam.setObject("1", forKey: "reg_type" as NSCopying)
        dicParam.setObject("1", forKey: "latitude" as NSCopying)
        dicParam.setObject("1", forKey: "longitude" as NSCopying)
        dicParam.setObject("Asia/Kolkata", forKey: "timezone" as NSCopying)
        dicParam.setObject("Surat", forKey: "location" as NSCopying)
        
        
        let dicImgParam:NSMutableDictionary = NSMutableDictionary()
        let dataImg = UIImageJPEGRepresentation(UIImage(named:"testing.jpg")!, 1)
        
        dicImgParam.setObject(dataImg as Any, forKey: "profilephoto" as NSCopying)//you can upload image,video,doc,xls,pdf or anyfile type of objects here as NSData object
        
        let objHelper:iHelperClass = iHelperClass()
        
        
        objHelper.iHelperAPI_FileUpload(urlMethodOrFile: "<ANY URL>/webservice.php", parameters: dicParam, parametersImage: dicImgParam, apiIdentifier: "IMAGE", delegate: self)
        

        
    }
    
    
    @IBAction func btnCallwsAsJSON_clicked(sender: AnyObject) {
        let objHelper:iHelperClass = iHelperClass()
        

        
        let strJSON :String = "{\"userId\" : \"13645\"}"
        
        
        objHelper.iHelperAPI_JSON(urlMethodOrFile: "<ANY URL>", json: strJSON, apiIdentifier: "JSON", delegate: self)
    }
    
    
    // MARK: iHelperClassDelegate
    func iHelperResponseSuccess(ihelper: iHelperClass) {
        
        if(ihelper.apiIdentifier == "get_identifier")
        {
            let stringJson  =  String(data: ihelper.responseData! as Data, encoding: String.Encoding.utf8)
            
            print("wenservice GET response >>> \(String(describing: stringJson))")
        }

        if(ihelper.apiIdentifier == "post_identifier")
        {
            let stringJson  =  String(data: ihelper.responseData! as Data, encoding: String.Encoding.utf8)
            
            print("wenservice POST response >>> \(String(describing: stringJson))")
        }

        
        if(ihelper.apiIdentifier == "JSON")
        {
            let stringJson  =  String(data: ihelper.responseData! as Data, encoding: String.Encoding.utf8)
            
            print("json response >>>> \(String(describing: stringJson))")
        }
        if(ihelper.apiIdentifier == "IMAGE")
        {
            
            let stringJson  =  String(data: ihelper.responseData! as Data, encoding: String.Encoding.utf8)
            
            print("IMAGE response >>>> \(String(describing: stringJson))")
        }
    }
    
    func iHelperResponseFail(error: NSError) {
        print("error : \(error)")
        
        let alert  =  UIAlertController(title: "Error", message: "ERROR : \(error)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

