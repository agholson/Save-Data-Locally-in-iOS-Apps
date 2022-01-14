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
//    @State var people = [Person]()
    
    // Binding to filter by this text
//    @State var filterByText = ""
    
    // Retrieve the collection of families from Core Data
    @FetchRequest(sortDescriptors: [])
    var families: FetchedResults<Family>
    
    var body: some View {
        VStack {
            // MARK: - Add Item
            Button(action: addItem) {
                Label("Create Family", systemImage: "plus")
            }
            
            // MARK: - Filter
            // Filters text every time the person edits the filter field and types/ stops typing
//            TextField("Filter Text", text: $filterByText, onEditingChanged: { _ in
//                // Every change to the data it fetches the list
//                fetchData()
//            })
//                .border(Color.black, width: 1)
//            TextField("Search for a name", text: $filterByText)
            
            
            List {
                // MARK: - Display People Fetched from Data Store
                // Loop through the array of Person objects above
                ForEach(families) { family in
//                    HStack {
                        // Display name
                        Text("\(family.name ?? ""), member count: \(family.members?.count ?? 0)")
                        // Display age
//                        Text(String(person.age))
                        // When someone taps on this, we change the name to Joe, then save that
//                            .onTapGesture {
//                                // Change name to Joe
//                                person.name = "Joe"
//
////                                person.name = "Tom"
////                                viewContext.delete(person)
//                                try! viewContext.save()
//                            }
//                    }
                    
                }
            }
        }
//         Whenever the filterByText value changes, it will retrieve the data from the database
//        .onChange(of: filterByText) { newValue in
//            // Fetches core data
//            fetchData()
//        }
    }
    
    func relationshipsSampleCode() {
        // Create new Family object within the NSManaged Object context
        let f = Family(context: viewContext)
        // Set the name
        f.name = "Robinsons Family"
        
        // Create a person in the same context
        let p = Person(context: viewContext)
        
        // Associate this person with this family
//        p.family = f
        
        // Add person from the family side
        f.addToMembers(p)
        
        // Save this information
        try! viewContext.save()
        
    }
    
        
    /*
     Fetches all of the Persons in the Core Data model based on the user's
     filter in the filterByText property
     */
//    func fetchData() {
//        // Create fetch request
//        let request = Person.fetchRequest()
//
//        // Set sort descriptors and predicates
//        request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
//
//        // The percent at signs will be replaced by our filterByText value
//        request.predicate = NSPredicate(format: "name contains %@", filterByText)
//
//        // Execute the query in the main thread, because it changes the UI
//        DispatchQueue.main.async {
//            do {
//                // Tries to execute the request
//                 let results = try viewContext.fetch(request)
//
//                // Returns list of people and assigns them to the Person array
//                self.people = results
//
//            } catch {
//                // Print any errors
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    private func addItem() {
        // Declare new Family object
        let family = Family(context: viewContext)
        
        // Set a random name for this family
        family.name = String("Family #\(Int.random(in: 0...20))")
        
        // Randomly set the number of members in the family
        let numberOfMembers = Int.random(in: 0...5)
        
        // Create a person for every member of the family
        for _ in 0...numberOfMembers {
            // Initializing the person, we can also pass in the NSManaged Object Context
            // This specifies that we want to store this object in Core Data
            let p = Person(context: viewContext)
            
            // Make the age random using a random 64-bit integer
            p.age = Int64.random(in: 1...80)
            p.name = "Tom"
            
            // Associate person with the family
            p.family = family
        }
        
        // Save to the data store
        do {
            try viewContext.save()
        }
        catch {
            // Catch any errors
        }
       
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
