    
    problem with 

    if error != .noError {

    }

// have to implement compariable (or equivalent)

much quick in this case (excuse the pun) to implement a simple method (or could it be property)?
    
    
    enum NomelaImageDocumentOpenErrors: Error {
        case noError
        case noContents(filename: String)
        case unableToOpen(filename: String)
        case invalidData(filename: String, Any.Type)
        case formatNotUnderstood
        
        func asAnyError() -> AnyError {
            return AnyError(self)
        }
        
        func isError() -> Bool {
            switch self {
            case .noError:
                return false
            default:
                return true
            }
        }
    }

    http://www.jessesquires.com/blog/swift-enumerations-and-equatable/
    https://medium.com/@jegnux/on-swift-enums-with-associated-value-equality-e815a768d9b0
    https://stackoverflow.com/questions/31548855/how-to-compare-enum-with-associated-values-by-ignoring-its-associated-value-in-s
    https://stackoverflow.com/questions/24339807/how-to-test-equality-of-swift-enums-with-associated-values
    https://appventure.me/2015/10/17/advanced-practical-enum-examples/#sec-2-6