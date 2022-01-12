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
//    @FetchRequest(sortDescriptors: [
//        NSSortDescriptor(key: "name", ascending: true), // Sort by name first
//        NSSortDescriptor(key: "age", ascending: true)  // Then sort by age
//    ], predicate: NSPredicate(format: "name contains 'Joe'"))
//    var people: FetchedResults<Person>
    
    // Initialize empty arraty of people
    @State var people = [Person]()
    
    // Binding to filter by this text
    @State var filterByText = ""
    
    var body: some View {
        VStack {
            // MARK: - Add Item
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
            
            // MARK: - Filter
            // Filters text every time the person edits the filter field and types/ stops typing
            TextField("Filter Text", text: $filterByText, onEditingChanged: { _ in
                // Every change to the data it fetches the list
                fetchData()
            })
//                .border(Color.black, width: 1)
            TextField("Search for a name", text: $filterByText)
            
            
            List {
                // MARK: - Display People Fetched from Data Store
                // Loop through the array of Person objects above
                ForEach(people) { person in
                    HStack {
                        // Display name
                        Text(person.name ?? "No name")
                        // Display age
                        Text(String(person.age))
                        // When someone taps on this, we change the name to Joe, then save that
                            .onTapGesture {
                                // Change name to Joe
                                person.name = "Joe"
                                
//                                person.name = "Tom"
//                                viewContext.delete(person)
                                try! viewContext.save()
                            }
                    }
                    
                }
            }
        }
//         Whenever the filterByText value changes, it will retrieve the data from the database
        .onChange(of: filterByText) { newValue in
            // Fetches core data
            fetchData()
        }
    }
        
    /*
     Fetches all of the Persons in the Core Data model based on the user's
     filter in the filterByText property
     */
    func fetchData() {
        // Create fetch request
        let request = Person.fetchRequest()
        
        // Set sort descriptors and predicates
        request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
        
        // The percent at signs will be replaced by our filterByText value
        request.predicate = NSPredicate(format: "name contains %@", filterByText)
        
        // Execute the query in the main thread, because it changes the UI
        DispatchQueue.main.async {
            do {
                // Tries to execute the request
                 let results = try viewContext.fetch(request)
                
                // Returns list of people and assigns them to the Person array
                self.people = results
                
            } catch {
                // Print any errors
                print(error.localizedDescription)
            }
        }
       
        
    }
    
    private func addItem() {
        
        // Initializing the person, we can also pass in the NSManaged Object Context
        // This specifies that we want to store this object in Core Data
        let p = Person(context: viewContext)
        // Make the age random using a random 64-bit integer
        p.age = Int64.random(in: 1...80)
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
