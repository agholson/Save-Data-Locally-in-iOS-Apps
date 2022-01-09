#  Save Data Locally in iOS Apps
This repo explains how to store data in your iOS app for persistent use, e.g.
the user closes the app, but not all of the data is lost (as normally happens).
The information comes from the excellent iOS Databases Module 5 course by https://codewithchris.com. Highly recommend CWC+!

# Table of contents
- [Save Data Locally in iOS Apps](#save-data-locally-in-ios-apps)
  - [How to Store Data Locally in an iOS app](#how-to-store-data-locally-in-an-ios-app)
- [Core Data Model](#core-data-model)
  - [Defining Entities](#defining-entities)
- [Persistence Container](#persistence-container)
- [Managed Object Context](#managed-object-context)
  - [Creating Data](#creating-data)
  - [Reading Data](#reading-data)
  - [Update Data](#update-data)
  - [Delete Data](#delete-data)
  - [Preview Data](#preview-data)

## How to Store Data Locally in an iOS app
These are the main steps to generate our CoreData:
1) Define Entities and their attributes in the Core Data model.
1) Generate classes from the Core Data model.
1) Reference the Persistence Container
1) Use `Managed Object Context` to save/ delete/ update Core Data.

# Core Data Model
In the Core Data model, the `.xcdatamodel` file, we define our `Entities` as well as attributes of those entities.
These entities represent our classes and their properties.

## Defining Entities
XCode auto-generates a demo Item `Entity` to use within our project. We click that same
`.xcdatamodel` file to add/ customize any other entities that we want to remain persistent
after closing the app.

### Manual Code Generation 
For this example, we use the codegen option on the right for manual code
gen. Here you define your attributes (property equivalents) for each of
the entitites. 
![xcuserdata screenshot](static/xcuserdata_screenshot.png) 
For an array type, we use the `transformable` type. Then, expand the right-hand side.
From here, in the custom class field you input that it is an array of a type of your choosing. 
In this example, we define an attribute as a String array. 
![String array attribute definition](static/array_definition.png)

Once you defined your Entity, you must create an `NSManaged Object Subclass` based on it. 
![Screenshot of editor instructions](static/NSManagedObjectSubclass.png)

This creates two new files. The first can be thought of as the normal Class in Swift.
The second is an extension of that class. You can modify the first. 
However, whenever you create new attributes/ change their types, it is best
to do this `.xcdatamodel` file, then re-generate another `NSManaged Object Subclass`
in order to use Core Data. 
![generatedClasses.png](static/generatedClasses.png)

### Auto-Code Generation (Default) 
However, by default entities use the `Class Definition` codegen. This 
allows Xcode to manage the entities/ their changes behind the scenes. In
this way, we do not have to manually generate a new `NSManaged Object Subclass`, because
Xcode takes care of this for us behind the scenes. This explains why
we do not see equivalent class files/ extensions for the auto-generated
`Item` entity.
![Code gen location](static/codeGen.png)

### Category Extension
Unlike, with our `Person` entity, where we can add custom methods to it, 
the `Item` entity does not allow us to do this.
We can gain back more control by switching the `codegen` option to the third one available.
![Category Extension option shown](static/categoryExtension.png)

This allows Xcode to manage the Extension file automatically in the background for us. 
While we can still control the class's methods in a normal manner. 

# Persistence Container
This is the third piece to the puzzle to use Core Data. You will find in 
your Xcode project a `Persistence` struct, which represents this container.
We use this struct to interact between the app and the Core Data SQLite databse.
Reference the persistence container in the following manner:
```
// Create instance of the PersistenceController
let a = PersistenceController()

// Reference the persistence container
a.container
```

Or better yet, the `Persistence` struct already includes an instance of the container.
This prevents us from needing to reload everything from the container, because
upon initialization it was already loaded for us. We can acces it in the
following way:
```
let container = PersistenceController.shared
```

Rather, we can make this container into a `singleton` by making the `init`
method in the `Persistence` struct private. This prevents the creation
of any other `Peristence` objects. Instead, you must use the `shared`
public attribute in order to use the container.
```
let container: NSPersistentContainer

private init(inMemory: Bool = false) {
```

# Managed Object Context
The Managed Object Context allows us to perform Create, Read, Update, Delete (CRUD)
operations in the Core Data datastore.  

XCode makes it easy to access the `Managed Object Context` by passing it
into the app from the root of the project as an `environment` value. This
Environment value is similar to the `EnvironmentObject` normally used to 
track the `ContentModel` within the app. It allows you to access the value
in any of the sub-views of the ContentView.
This code is generated automatically for you, when you select Core Data.
```
let persistenceController = PersistenceController.shared

var body: some Scene {
    WindowGroup {
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
```

In the `ContentView`, we access the passed-in `Managed Object Context` by using the same 
path as defined above in the `Core_Data_DemoApp` view.
```
@Environment(\.managedObjectContext) private var viewContext
```

## Creating Data
```
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
```

## Reading Data
Behind the scenes, if you selected the `codegen` options of `Class Definition` 
or `Category/Extension`, Xcode generates code for us to retrieve all of 
the `Entity` objects from the data store. To see this code, you can
change one of the codegen types for one of your entities to `Manual`. 
Then, while keeping that entity selected go to `Editor -> Create NSManaged Object Subclass`.
You can see in here a method name `fetchRequest` that will get all of the entities
with the `Person` type from the data store.
```
extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: Int64
    @NSManaged public var array: [String]?

}

extension Person : Identifiable {

}
```
You can easily get all of the `Person` objects in the data store with the following code:
```
// Used to fetch all of our people in the data store
@FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
```

## Update Data
You can simply change the object in question, then use the `viewContext.save()` to savw it.

## Delete Data
In order to delete data, you can pass in the object, similar to appending the object to an array. However,
in order to lock-in the changes, you must then call the `.saveData()` method.
```
viewContext.delete(person)
try! viewContext.save()
```

## Preview Data
In order to Preview Core Data, you need to make sure the `preview` attribute within the Persistence struct
is setup.
```
static var preview: PersistenceController = {
    // Uses inMemory flag, so the objects are not truly added to the data store
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for _ in 0..<10 {
        // Create dummy persons
        let newItem = Person(context: viewContext)
        // Set name to Sam
        newItem.name = "Sam"
    }
    do {
        // Saves into temp file
        try viewContext.save()
    } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
}()
```
