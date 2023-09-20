//
//  FilterStruct.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 12.8.23.
//

import SwiftUI

protocol RawValueProtocol {
    var rawValue: String { get }
}

struct CriteriaPropertyOption: Identifiable {
    let id: String
    let label: String
}

class PropertyOptionsObserver: ObservableObject {
    private var itemsMap: [String: CriteriaPropertyOption] = [:]
    
    init(items: [CriteriaPropertyOption], exclude: [String]) {
        self.itemsMap = PropertyOptionsObserver.reduceToMap(items, exclude: exclude)
    }
    
    func remove(_ id: String) -> CriteriaPropertyOption? {
        self.objectWillChange.send()
        return itemsMap.removeValue(forKey: id)
    }
    
    func insert(_ item: CriteriaPropertyOption) {
        self.objectWillChange.send()
        itemsMap[item.id] = item
    }
    
    func set(_ items: [CriteriaPropertyOption]) {
        self.itemsMap = PropertyOptionsObserver.reduceToMap(items)
        self.objectWillChange.send()
    }
    
    func get() -> Binding<[CriteriaPropertyOption]> {
        return Binding(
            get: {
                self.itemsMap.values.sorted { a,b in a.id < b.id }
            }, set: { items in
                self.itemsMap = PropertyOptionsObserver.reduceToMap(items)
            }
        )
    }
    
    func isEmpty() -> Bool {
        return itemsMap.isEmpty
    }
    
    func getNext() -> CriteriaPropertyOption? {
        return itemsMap.values.first
    }
    
    private static func reduceToMap(_ items: [CriteriaPropertyOption], exclude: [String] = []) -> [String: CriteriaPropertyOption] {
        return items.reduce(([String: CriteriaPropertyOption]())) { acc, value in
            if exclude.contains(value.id) {
                return acc
            }
            var data = acc
            data[value.id] = value
            return data
        }
    }
}


protocol FilterEnumProtocol: Hashable, CaseIterable, RawValueProtocol {
}

protocol FilterOptionProtocol: Identifiable, Comparable {
    associatedtype FilterEnum : FilterEnumProtocol
    associatedtype FilterOption: FilterOptionProtocol
    
    var id: UUID { get }
    var order: Int { get }
    var name: String { get }
    var label: String { get }
    var selected: FilterEnum { get set }
    
    func options() -> [FilterEnum]
    mutating func select(_ item: FilterEnum) -> Void
    mutating func select(_ value: String) -> Void
    func with(order value: Int) -> FilterOption
}

protocol AnyFilterOptionProtocol {
    var id: UUID { get }
    var order: Int { get }
    var name: String { get }
    var label: String { get }
    var selected: String { get set }
    func options() -> [String]
    mutating func select(_ item: any FilterEnumProtocol) -> Void
    func with(order value: Int) -> AnyFilterOptionProtocol
}

extension FilterOptionProtocol {
    func asAnyFilterOption() -> any AnyFilterOptionProtocol {
        return AnyFilterOption(self)
    }
}

struct AnyFilterOption<ConcreteFilter: FilterOptionProtocol>: AnyFilterOptionProtocol {
 
    private var base: ConcreteFilter
    typealias FilterEnum = ConcreteFilter.FilterEnum
    
    init(_ base: ConcreteFilter) {
        self.base = base
    }
    
    var id: UUID { return base.id }
    var order: Int { return base.order }
    var name: String { return base.name }
    var label: String { return base.label }
    var selected: String {
        get { return base.selected.rawValue }
        set { base.select(newValue) }
    }
    
    func options() -> [String] {
        return base.options().map { option in
            return option.rawValue
        }
    }
    
    mutating func select(_ item: any FilterEnumProtocol) {
        base.select(item as! FilterEnum)
    }
    
    static func == (lhs: AnyFilterOption<ConcreteFilter>, rhs: AnyFilterOption<ConcreteFilter>) -> Bool {
        return lhs.base == rhs.base
    }
    
    static func < (lhs: AnyFilterOption<ConcreteFilter>, rhs: AnyFilterOption<ConcreteFilter>) -> Bool {
        return lhs.order < rhs.order
    }
    
    func with(order value: Int) -> AnyFilterOptionProtocol {
        return base.with(order: value).asAnyFilterOption()
    }
}
