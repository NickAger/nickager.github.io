//: Understanding [Any] quirks

import Foundation

func process(anArray : [Any]) {
    
}

// remove [Any] type declaration to produce a runtime error
let a : [Any] = [1,2,[3],[4,[5,6]],[[7]], 8]
process(a)

func process2(anArray : [Any]) {
    for element in anArray {
        if let intValue = element as? Int {
            print("intValue = \(intValue)")
        } else {
            let arrayValue = element as! [Any]
            process2(arrayValue)
        }
    }
}

// Could not cast value of type 'Swift.Array<Swift.Int>' (0x10c9b5028) to 'Swift.Array<protocol<>>' (0x10c9b5130
// process2([1,2,[3],[4,[5,6]],[[7]], 8])

func process3(anArray : [Any]) {
    for element in anArray {
        if let intValue = element as? Int {
            print("intValue = \(intValue)")
        } else {
            let arrayValue = convertToArray(element)
            process3(arrayValue)
        }
    }
}

// see http://stackoverflow.com/questions/31697093/cannot-pass-any-array-type-to-a-function-which-takes-any-as-parameter
func convertToArray(value: Any) -> [Any] {
    let nsarrayValue = value as! NSArray
    return nsarrayValue.map {$0 as Any}
}
 process3([1,2,[3],[4,[5,6]],[[7]], 8])




