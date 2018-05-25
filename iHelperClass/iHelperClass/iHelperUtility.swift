//
//  iHelperUtility.swift
//  iHelperClass
//
//  Created by Chirag Lukhi on 13/09/14.
//  Copyright (c) 2014 iChirag. All rights reserved.
//

import Foundation
import SystemConfiguration

public class iHelperUtility: NSObject
{
    override init()
    {
        super.init();
    }
    
    // MARK: UTILITY
    
    /// Reachability Method to check Internet available or not
    func isInternetAvailable() -> Bool {
        var zeroAddress  =  sockaddr_in()
        zeroAddress.sin_len  =  UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family  =  sa_family_t(AF_INET)
        
        let defaultRouteReachability  =  withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags  =  SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable  =  flags.contains(.reachable)
        let needsConnection  =  flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    /// Dictionary to query string conversion
    public func generateParam(dicParam:NSDictionary?)-> String?
    {
        
        var param:String  =  ""
        if (dicParam == nil || dicParam?.count == 0)
        {
            return param
        }
        
        for (key, value) in dicParam! {
            param  =  "\(param)\(key as! String)=\(value as! String)&"
        }
        
        return String(param.dropLast())
        
//        return param.substring(to: param.count - 1) as String
    }

}

