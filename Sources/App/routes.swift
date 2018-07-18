import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    router.get("hello","people") { req -> String in
        return "Hello, People!"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello, \(name)!"
    }
    
    router.post("api", "v1", "person") { req -> Future<Person> in
        return try req.content.decode(Person.self)
            .flatMap(to: Person.self) { person in
                return person.save(on: req)
        }
    }
    
    router.get("api", "v1", "people") { req -> Future<[Person]> in
        
        switch req.query[String.self, at: "sort"] {
        case "asc":
            return Person.query(on: req).sort(\Person.name, .ascending).all()
        case "desc":
            return Person.query(on: req).sort(\Person.name, .descending).all()
        default:
            return Person.query(on: req).all()
        }
    }
    
    router.get("api", "v1", "people", "random") { req -> Future<Person> in
        
        return Person.query(on: req)
            .all()
            .flatMap(to: Person.self) { people in
                
                let randomNumber: Int
                #if os(Linux)
                    srandom(UInt32(time(nil)))
                    randomNumber = Int(random() % people.count) + 1
                #else
                    randomNumber = Int(arc4random_uniform(UInt32(people.count))) + 1
                #endif

                return Person.query(on: req)
                    .filter(\.id == randomNumber)
                    .first()
                    .map(to: Person.self) { person in
                        
                        guard let person = person else {
                            
                            throw Abort(.notFound)
                        }
                        
                        return person
                }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
