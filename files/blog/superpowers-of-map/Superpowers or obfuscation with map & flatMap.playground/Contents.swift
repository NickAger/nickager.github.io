//: Playground - noun: a place where people can play

import UIKit

let twos = (1...10).map { $0 * 2 }
// twos == [2,4,6 ... 20]


UIImage(named: "anImage")?.size

let imageSize = UIImage(named: "anImage").map {$0.size}

let hello = ["arrays", "in", "arrays"].map {Array($0.characters)}

hello.count

hello[0].count


let arrayOfArrayOfCharacters = ["array", "of", "arrays"].map {print(Array($0.characters)); Array($0.characters)}
let arrayOfCharacters = ["array", "of", "characters"].flatMap {Array($0.characters)}

print(arrayOfCharacters)
arrayOfCharacters.count

let sequence1 = zip("hello".characters, "world".characters)
sequence1.dynamicType

let sequence2 = AnySequence(sequence1)
sequence2.dynamicType


