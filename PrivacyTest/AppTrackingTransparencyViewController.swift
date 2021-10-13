//
//  AppTrackingTransparencyViewController.swift
//  AppTrackingTransparencyViewController
//
//  Created by zhgchgli on 2021/8/27.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class AppTrackingTransparencyViewController: UIViewController {
    
    
    @IBOutlet weak var getIDFAButton: UIButton!
    @IBOutlet weak var getIDFVButton: UIButton!
    @IBOutlet weak var askingPermissionButton: UIButton!
    @IBOutlet weak var permissionStatusLabel: UILabel!
    @IBOutlet weak var IDFAResultTextField: UITextField!
    @IBOutlet weak var IDFVResultTextField: UITextField!
    @IBOutlet weak var keyChainUUIDTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIDFAButton.addTarget(self, action: #selector(getIDFA), for: .touchUpInside)
        getIDFVButton.addTarget(self, action: #selector(getIDFV), for: .touchUpInside)
        askingPermissionButton.addTarget(self, action: #selector(askingPermission), for: .touchUpInside)
        keyChainUUIDTextField.text = getUUID()
        updatePermission(ATTrackingManager.trackingAuthorizationStatus)
    }
    
    private func updatePermission(_ status:ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self.permissionStatusLabel.text = "authorized"
        case .notDetermined:
            self.permissionStatusLabel.text = "notDetermined"
        case .restricted:
            self.permissionStatusLabel.text = "restricted"
        case .denied:
            self.permissionStatusLabel.text = "denied"
        @unknown default:
            self.permissionStatusLabel.text = "@unknown"
        }
    }
    
    private func getUUID() -> String {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : "DEVICE_UUID",
            kSecReturnData as String  : kCFBooleanTrue as Any,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr,let dataTypeRef = dataTypeRef as? Data,let uuid = String(data:dataTypeRef, encoding: .utf8) {
            return uuid
        } else {
            let DEVICE_UUID:String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
            if let data = DEVICE_UUID.data(using: .utf8) {
                let query = [
                    kSecClass as String       : kSecClassGenericPassword as String,
                    kSecAttrAccount as String : "DEVICE_UUID",
                    kSecValueData as String   : data ] as [String : Any]
            
                SecItemDelete(query as CFDictionary)
                SecItemAdd(query as CFDictionary, nil)
            }
            return DEVICE_UUID
        }
    }
    
    @objc private func getIDFA(_ sender: Any) {
        self.IDFAResultTextField.text = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    @objc private func getIDFV(_ sender: Any) {
        self.IDFVResultTextField.text = UIDevice.current.identifierForVendor?.uuidString
    }
    
    @objc private func askingPermission(_ sender: Any) {
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.updatePermission(status)
            }
        }
    }
    
}
