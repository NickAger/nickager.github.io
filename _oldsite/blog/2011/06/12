---
title: "Understanding Pier's PRContext"
tags: "Pier Smalltalk Seaside"
date: 2011-06-12
---

Pier (and Seaside) use *dynamic variables* to retrieve the value of the session or current context whose value is defined at runtime by the calling context. They enhance testability as mock or known _dynamic variable_ can be defined within the context of a test.

How do _dynamic variables_ work. Examining the code:

```Smalltalk
PRCurrentContext class
value
	"This is the read accessor of the current context."

	| holder |
	holder := self signal.
	^ holder isNil ifFalse: [ holder context ]
```

```Smalltalk
PRCurrentContext class
value: aContext
	"This is the write accessor of the current context."

	self signal context: aContext
```

notice how these methods call `context/context:` on the results from: `self signal` which in turn is the 'anObject` passed in:

```Smalltalk
PRCurrentContext class
use: anObject during: aBlock
	^ aBlock on: self do: [ :notification | notification resume: anObject ]
```

`PRContextFilter` passes presenter to `use:during:`

```Smalltalk
PRContextFilter
handleFiltered: aRequestContext
	^ PRCurrentContext use: presenter during: [ super handleFiltered: aRequestContext ]
```

`PRContextFilter` is created in:

```Smalltalk
PRPierFrame
initialRequest: aRequest
	| structure following |
	super initialRequest: aRequest.
	self session 
		addFilter: (PRContextFilter on: self).
	following := self context
		structure: (structure := self 
			parseStructure: aRequest 
			ifAbsent: [ ^ self notFound ])
		command: (self
			parseCommand: aRequest
			structure: structure).
	following command
		initialRequest: aRequest.
	self context: following
```

simples...
