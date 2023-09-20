//
//  FilterCriteria.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 19.8.23.
//

import Foundation


enum LanguageEnum: String, FilterEnumProtocol {
    case Java = "java"
    case Javascript = "javascript"
    case python = "python"
}

struct LanguageFilter : FilterOptionProtocol {
    
    typealias FilterOption = Self
    typealias FilterEnum = LanguageEnum
    
    let id = UUID()
    let order: Int
    let name: String
    let label: String
    var selected: FilterEnum
    
    init(order: Int, name: String, label: String, selected: FilterEnum) {
        self.order = order
        self.name = name
        self.label = label
        self.selected = selected
    }
    
    init(name: String, label: String, selected: FilterEnum) {
        self.order = -1
        self.name = name
        self.label = label
        self.selected = selected
    }
    
    func options() -> [FilterEnum] {
        return FilterEnum.allCases
    }
    
    func with(order value: Int) -> Self {
        return Self(order: value, name: self.name, label: self.label, selected: self.selected)
    }
    
    mutating func select(_ item: FilterEnum) {
        self.selected = item
    }
    
    mutating func select(_ value: String) {
        guard let newEnumValue = FilterEnum(rawValue: value) else { return }
        selected = newEnumValue
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.order < rhs.order
    }
 
}

enum DificultyEnum: String, FilterEnumProtocol {
    case Easy = "easy"
    case Medium = "medium"
    case Hard = "hard"
}

struct DificultyFilter : FilterOptionProtocol {
    
    typealias FilterOption = Self
    typealias FilterEnum = DificultyEnum
    
    let id = UUID()
    let order: Int
    let name: String
    let label: String
    var selected: FilterEnum
    
    init(order: Int, name: String, label: String, selected: FilterEnum) {
        self.order = order
        self.name = name
        self.label = label
        self.selected = selected
    }
    
    init(name: String, label: String, selected: FilterEnum) {
        self.order = -1
        self.name = name
        self.label = label
        self.selected = selected
    }
    
    func options() -> [FilterEnum] {
        return FilterEnum.allCases
    }
    
    func with(order value: Int) -> Self {
        return Self(order: value, name: self.name, label: self.label, selected: self.selected)
    }
    
    mutating func select(_ item: FilterEnum) {
        self.selected = item
    }
    
    mutating func select(_ value: String) {
        guard let newEnumValue = FilterEnum(rawValue: value) else { return }
        selected = newEnumValue
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.order < rhs.order
    }
    
}

