//
//  ConfigManager.swift
//  ClashX
//
//  Created by CYC on 2018/6/12.
//  Copyright © 2018年 yichengchen. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class ConfigManager {
    
    static let shared = ConfigManager()
    var apiPort = "8080"
    private init(){refreshApiPort()}
    
    var currentConfig:ClashConfig?{
        get {
            return currentConfigVariable.value
        }
        
        set {
            currentConfigVariable.value = newValue
        }
    }
    var currentConfigVariable = Variable<ClashConfig?>(nil)
    
    var proxyPortAutoSet:Bool {
        get{
            return UserDefaults.standard.bool(forKey: "proxyPortAutoSet")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "proxyPortAutoSet")
        }
    }
    let proxyPortAutoSetObservable = UserDefaults.standard.rx.observe(Bool.self, "proxyPortAutoSet")
    
    var showNetSpeedIndicator:Bool {
        get{
            return UserDefaults.standard.bool(forKey: "showNetSpeedIndicator")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "showNetSpeedIndicator")
        }
    }
    let showNetSpeedIndicatorObservable = UserDefaults.standard.rx.observe(Bool.self, "showNetSpeedIndicator")
    
    static var apiUrl:String{
        get {
            return "http://127.0.0.1:\(shared.apiPort)"
        }
    }
    
    static var selectedProxyMap:[String:String] {
        get{
            return UserDefaults.standard.dictionary(forKey: "selectedProxyMap") as? [String:String] ?? ["Proxy":"ProxyAuto"]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedProxyMap")
        }
    }
    
    static var selectOutBoundMode:ClashProxyMode {
        get{
            return ClashProxyMode(rawValue: UserDefaults.standard.string(forKey: "selectOutBoundMode") ?? "") ?? .rule
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectOutBoundMode")
        }
    }
    
    static var selectLoggingApiLevel:ClashLogLevel {
        get{
            return ClashLogLevel(rawValue: UserDefaults.standard.string(forKey: "selectLoggingApiLevel") ?? "") ?? .info
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectLoggingApiLevel")
        }
    }
    
    func refreshApiPort(){
        if let ini =
            parseConfig("\(NSHomeDirectory())/.config/clash/config.ini"),
            let controller = ini["General"]?["external-controller"]{
            if controller.contains(":") {
                if let port = controller.split(separator: ":").last {
                    apiPort = String(port)
                    return;
                }
            }
        }
        ConfigFileFactory.copySimpleConfigFile()
        refreshApiPort()
    }
    

    
}
