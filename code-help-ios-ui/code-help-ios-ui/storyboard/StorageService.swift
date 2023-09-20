//
//  StorageService.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 20.9.23.
//

import Foundation


class StorageService {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func get<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return decode(data)
    }
    
    func put<T: Encodable>(_ object: T, forKey key: String) {
        guard let data = encode(object) else { return }
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    private func encode<T: Encodable>(_ object: T) -> Data? {
        do {
            return try encoder.encode(object)
        } catch {
            print(error)
            return nil;
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
