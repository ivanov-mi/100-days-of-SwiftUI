//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Martin Ivanov on 5/24/24.
//

import SwiftUI
import SwiftData
import CodeScanner

enum FilterType {
    case none
    case contacted
    case uncontacted
}

enum SortOrder: String {
    case name = "Name"
    case dateAdded = "Date Added"
    
    var sortDescriptor: SortDescriptor<Prospect> {
        switch self {
        case .name:
            SortDescriptor(\Prospect.name)
        case .dateAdded:
            SortDescriptor(\Prospect.dateAdded)
        }
    }
}

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isShowingScanner = false
    @State private var isShowingSortOrderMenu = false
    @State private var sortOrder: SortOrder = .name
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var body: some View {
        NavigationStack {
            ProspectsListingView(filter: filter, sortOrder: sortOrder)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Scan", systemImage: "qrcode.viewfinder") {
                            isShowingScanner = true
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Order by", systemImage: "arrow.up.arrow.down") {
                            isShowingSortOrderMenu = true
                        }
                    }

                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "PaulHudson\npaul@hackingwithswift.com", completion: handleScan)
                }
                .actionSheet(isPresented: $isShowingSortOrderMenu) {
                    ActionSheet(title: Text("Sort by"), buttons: [
                        .default(Text((self.sortOrder == .name ? "✓ " : "") + "Name"), action: { self.sortOrder = .name }),
                        .default(Text((self.sortOrder == .dateAdded ? "✓ " : "") + "Date Added"), action: { self.sortOrder = .dateAdded }),
                    ])
                }
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
