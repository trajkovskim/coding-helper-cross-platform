//
//  Filter.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 12.8.23.
//

import SwiftUI


class FilterSelectState: ObservableObject {
    
    private var ordering = 0;
    private var properties: [UUID: AnyFilterOptionProtocol] = [:]
    private var excluded: Set<String> = []
    
    func add(_ prop: AnyFilterOptionProtocol) {
        self.objectWillChange.send()
        let newProp = prop.with(order: ordering);
        properties[newProp.id] = newProp
        ordering += 1
    }
    
    func remove(_ id: UUID) {
        self.objectWillChange.send()
        properties.removeValue(forKey: id)
    }
    
    func getBinding(for id: UUID) -> Binding<String> {
        return Binding (
            get: { [self] in
                return self.properties[id]?.selected ?? ""
            },
            set: { value in
                self.properties[id]!.selected = value
                self.objectWillChange.send()
            }
        )
    }
    
    func getOptions(for id: UUID) -> [String] {
        return self.properties[id]!.options()
    }
    
    func nextOrder() -> Int {
        let currentOrder = ordering
        ordering += 1
        return currentOrder
    }
    
    func getValues() -> [AnyFilterOptionProtocol]  {
        return properties.values.sorted { a, b in
            a.order < b.order
        }
    }
    
    func exclude(_ items: [String]) {
        excluded.formUnion(items)
    }
    
    func isEmpty() -> Bool {
        return properties.isEmpty
    }
}

struct FilterPropertyDisplay: Identifiable {
    let id: UUID
    var name: String
    var label: String
}

class FilterPropertyOptionsObserver: ObservableObject {
    private var itemsMap: [UUID: AnyFilterOptionProtocol] = [:]
    
    init(items: [AnyFilterOptionProtocol], exclude: [String]) {
        self.itemsMap = Self.reduceToMap(items, exclude: exclude)
    }
    
    init(items: [any FilterOptionProtocol], exclude: [String]) {
        self.itemsMap = Self.reduceToMap(items.map { item in item.asAnyFilterOption() }, exclude: exclude)
    }
    
    
    func remove(_ id: UUID) -> AnyFilterOptionProtocol? {
        self.objectWillChange.send()
        return itemsMap.removeValue(forKey: id)
    }
    
    func insert(_ item: AnyFilterOptionProtocol) {
        self.objectWillChange.send()
        itemsMap[item.id] = item
    }
    
    func set(_ items: [AnyFilterOptionProtocol]) {
        self.itemsMap = Self.reduceToMap(items)
        self.objectWillChange.send()
    }
    
    func at(_ id: UUID) -> AnyFilterOptionProtocol? {
        return itemsMap[id]
    }
    
    func get() -> Binding<[FilterPropertyDisplay]> {
        return Binding(
            get: {
                self.to()
            }, set: { items in
                return;
            }
        )
    }
    
    private func to() -> [FilterPropertyDisplay] {
        return self.itemsMap.values.sorted { a,b in a.name < b.name } .map { i in
            FilterPropertyDisplay(id: i.id, name: i.name, label: i.label)
        }
    }
    
    func isEmpty() -> Bool {
        return itemsMap.isEmpty
    }
    
    func count() -> Int {
        return itemsMap.count
    }
    
    func getNext() -> AnyFilterOptionProtocol? {
        return itemsMap.values.first
    }
    
    private static func reduceToMap(_ items: [AnyFilterOptionProtocol], exclude: [String] = []) -> [UUID: AnyFilterOptionProtocol] {
        return items.reduce(([UUID: AnyFilterOptionProtocol]())) { acc, value in
            if exclude.contains(value.name) {
                return acc
            }
            var data = acc
            data[value.id] = value
            return data
        }
    }
}

struct FilterSelect: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var state = FilterSelectState()


    @StateObject private var propertyOptions: FilterPropertyOptionsObserver
    @State var selected: UUID = UUID()

    let handleDone: (([AnyFilterOptionProtocol]) -> Void)?

    init(exclude excluded: [String] = [], propertyOptions: [any FilterOptionProtocol], onDone: (([AnyFilterOptionProtocol]) -> Void)? = nil) {
        handleDone = onDone
        self._propertyOptions = StateObject(wrappedValue: .init(items: propertyOptions, exclude: excluded))
        self._selected = State(wrappedValue: self.propertyOptions.getNext()?.id ?? .init())
    }
    
    
    private func closeOptionProp(_ property: AnyFilterOptionProtocol) {
        state.remove(property.id)
        propertyOptions.insert(property)
        if propertyOptions.count() == 1 {
            selected = propertyOptions.getNext()!.id
        }
    }
    
    private func addSortProperty() {
        let option = propertyOptions.remove(selected)
        if let nextSelection = propertyOptions.getNext()?.id {
            selected = nextSelection
        }
        if let option = option {
            state.add(option)
        }
    }
    
    var body: some View {
        VStack {
            ForEach(state.getValues(), id: \.id) { property in
                OptionProp(
                    selected: state.getBinding(for: property.id),
                    options: state.getOptions(for: property.id),
                    title: property.label
                ) {
                    option in Text(option)
                } close: {
                    closeOptionProp(property)
                }
            }
            HStack(alignment: .center) {
                if !propertyOptions.isEmpty() {
                    Picker("Select", selection: $selected) {
                        ForEach(propertyOptions.get()) { option in
                            Text(option.name.wrappedValue)
                        }
                    }.pickerStyle(.menu)
                    Button {
                        addSortProperty()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                Spacer()
                Button("Done") {
                    handleDone?(state.getValues())
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(40)
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        FilterSelect(propertyOptions: [
            LanguageFilter(name: "language", label: "Language:", selected: .Java),
            DificultyFilter(name: "dificulty", label: "Dificulty:", selected: .Easy)
        ])
    }
}
