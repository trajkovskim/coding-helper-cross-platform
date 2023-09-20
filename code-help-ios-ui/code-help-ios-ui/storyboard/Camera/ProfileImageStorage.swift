//
//  ProfileImageStorage.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 20.9.23.
//

import UIKit

class ProfileImageStorage {
    private static let storageService = StorageService()
    private static let profileImageStorageKey = "ProfileImageStorageKey"
    
    static let shared = ProfileImageStorage()
    
    func store(image: UIImage) {
        Self.storageService.put(image.pngData(), forKey: Self.profileImageStorageKey)
    }
    
    func get() -> UIImage? {
        let data: Data? = Self.storageService.get(forKey: Self.profileImageStorageKey)

        if let data = data {
            return UIImage(data: data)
        }

        return nil
    }
    
    func clear() {
        Self.storageService.remove(forKey: Self.profileImageStorageKey)
    }
}
