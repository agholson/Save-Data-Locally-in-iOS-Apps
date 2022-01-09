//
//  ContentView.swift
//  Shared
//
//  Created by Leone on 1/9/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    // Used to fetch all of our people in the data store
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    var body: some View {
        VStack {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
            List {
                // MARK: - Display People Fetched from Data Store
                ForEach(people) { person in
                    Text(person.name ?? "No name")
                    // When someone taps on this, we change the name to Joe, then save that
                        .onTapGesture {
                            person.name = "Tom"
                            viewContext.delete(person)
                            try! viewContext.save()
                        }
                    
                }
            }
        }
        //        NavigationView {
        //            List {
        //                ForEach(items) { item in
        //                    NavigationLink {
        //                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
        //                    } label: {
        //                        Text(item.timestamp!, formatter: itemFormatter)
        //                    }
        //                }
        //                .onDelete(perform: deleteItems)
        //            }
        //            .toolbar {
        //#if os(iOS)
        //                ToolbarItem(placement: .navigationBarTrailing) {
        //                    EditButton()
        //                }
        //#endif
        //                ToolbarItem {
        //                    Button(action: addItem) {
        //                        Label("Add Item", systemImage: "plus")
        //                    }
        //                }
        //            }
        //            Text("Select an item")
        //        }
        
        
        
    }
    
    private func addItem() {
        
        // Initializing the person, we can also pass in the NSManaged Object Context
        // This specifies that we want to store this object in Core Data
        let p = Person(context: viewContext)
        p.age = 20
        p.name = "Tom"
        
        // Save to the data store
        do {
            try viewContext.save()
        }
        catch {
            // Catch any errors
        }
        //        withAnimation {
        //            let newItem = Item(context: viewContext)
        //            newItem.timestamp = Date()
        //
        //            do {
        //                try viewContext.save()
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nsError = error as NSError
        //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //            }
        //        }
    }
    

}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
