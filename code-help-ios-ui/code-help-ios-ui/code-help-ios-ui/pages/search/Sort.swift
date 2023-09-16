//
//  Sort.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 5.8.23.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case Ascending = "Ascending"
    case Descending = "Descending"
}


struct SortingProp: Identifiable, Comparable {
    
    var id = UUID()
    var order: Int
    var name: String
    var label: String
    var selectedOption: SortOption = SortOption.Ascending
    
    static func < (lhs: SortingProp, rhs: SortingProp) -> Bool {
        return lhs.order < rhs.order
    }
}


class SortSelectState: ObservableObject {
    private var ordering = 0;
    private var properties: Dictionary<UUID, SortingProp> = [:]
    private var excluded: Set<String> = []
    
    func add(_ prop: SortingProp) {
        properties[prop.id] = prop
        self.objectWillChange.send()
    }
    
    func remove(_ id: UUID) {
        properties.removeValue(forKey: id)
        self.objectWillChange.send()
    }
    
    func getBinding(for id: UUID) -> Binding<SortOption> {
        return Binding (
            get: { [self] in
                self.properties[id]!.selectedOption
            },
            set: { value in
                self.properties[id]!.selectedOption = value
                self.objectWillChange.send()
            }
        )
    }
    
    func nextOrder() -> Int {
        let currentOrder = ordering
        ordering += 1
        return currentOrder
    }
    
    func getValues() -> [SortingProp]  {
        return properties.values.sorted(by: < )
    }
    
    func exclude(_ items: [String]) {
        excluded.formUnion(items)
    }
    
    func isEmpty() -> Bool {
        return properties.isEmpty
    }
}


struct SortSelect: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var state = SortSelectState()
    @StateObject private var propertyOptions: PropertyOptionsObserver
    @State private var selected: String = ""
    
    var done: (([SortingProp]) -> Void)?
    
    init(exclude excluded: [String] = [], propertyOptions: [CriteriaPropertyOption], done: (([SortingProp]) -> Void)? = nil) {
        self._propertyOptions = StateObject(wrappedValue: .init(items: propertyOptions, exclude: excluded))
        self._selected = State(wrappedValue: self.propertyOptions.getNext()?.id ?? .init())
        self.done = done
    }
    
    private func closeOptionProp(_ property: SortingProp) {
        state.remove(property.id)
        propertyOptions.insert(CriteriaPropertyOption(id: property.name, label: property.label))
        if selected == "" {
            selected = propertyOptions.getNext()!.id
        }
    }
    
    private func addSortProperty() {
        let option = propertyOptions.remove(selected)
        selected = propertyOptions.getNext()?.id ?? ""
        if let option = option {
            state.add(SortingProp(order: state.nextOrder(), name: option.id, label: option.label))
        }
    }
    
    
    var body: some View {
        VStack {
            ForEach(state.getValues()) { property in
                OptionProp(selected: state.getBinding(for: property.id), options: SortOption.allCases, title: property.label) {
                    option in Text(option.rawValue)
                } close: {
                    closeOptionProp(property)
                }
            }
            HStack(alignment: .center) {
                if !propertyOptions.isEmpty() {
                    Picker("Select", selection: $selected) {
                        ForEach(propertyOptions.get()) { option in
                            Text(option.id)
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
                    done?(state.getValues())
                    dismiss()
                }
                .disabled(state.isEmpty())
                .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(40)
    }
}
