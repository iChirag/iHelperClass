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
        
        var objAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        objAddress.sin_len = UInt8(sizeofValue(objAddress))
        objAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&objAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    /// Dictionary to query string conversion
    public func generateParam(dicParam:NSDictionary?)-> NSString?
    {
        
        var param:NSString=""
        if (dicParam==nil || dicParam?.count==0)
        {
            return param
        }
        
        for (key, value) in dicParam! {
            param = param + "\(key as String)=\(value as String)&"
        }
        
        return param.substringToIndex(param.length-1)
    }

}