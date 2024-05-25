//
//  ProspectsListingView.swift
//  HotProspects
//
//  Created by Martin Ivanov on 5/25/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ProspectsListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    @State private var selectedProspects: Set<Prospect> = []
    
    let filter: FilterType
    
    var body: some View {
        List(prospects, selection: $selectedProspects) { prospect in
            NavigationLink {
                EditView(prospect: prospect)
            } label: {
                HStack {
                    if filter == .none {
                        Image(systemName: prospect.isContacted ? "envelope" : "envelope.badge")
                    }
                    
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            
            if selectedProspects.isEmpty == false {
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Selected", action: delete)
                }
            }
        }
    }
    
    func delete() {
        for prospect in prospects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    init(filter: FilterType, sortOrder: SortOrder) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: [sortOrder.sortDescriptor])
        } else {
            _prospects = Query(sort: [sortOrder.sortDescriptor])
        }
    }
}

#Preview {
    ProspectsListingView(filter: .none, sortOrder: SortOrder.name)
}
