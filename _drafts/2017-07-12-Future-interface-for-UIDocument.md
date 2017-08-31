Describe the future interface in NomelaImageDocument and DiffTextDocument.
Reasons for using UIDocument - its handles all the file coordination boilerplate: request -> cloud stuff happens -> callback
Look at sample code that uses UIDocument
Compare with callback approach

Having to use 

Odd design from Apple forcing derivation of class. Would have been more obvious if it had a delegate based callback.

Base the `DiffTextDocument` type on UIDocument to gain UIDocument benefits when reading files from iCloud.
//  See UIDocument documentation and "Building Cloud based apps" session 234, WWDC2015 - https://developer.apple.com/videos/play/wwdc2015-234/