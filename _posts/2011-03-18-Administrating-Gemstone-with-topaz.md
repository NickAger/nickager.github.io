---
title: "Administrating Gemstone with topaz"
date: 2011-03-08
tags: "Gemstone, sysadmin, devops"
layout: post
---

Some examples of using `topaz` - Gemstone's command-line - (command-line Smalltalk!) - its often easier than using `Gemtools` for administration work on a remote machine.

#### Example 1
```
$ topaz
topaz> set user DataCurator pass swordfish gems seaside
topaz> login
[07/02/11 03:04:52.545 UTC] gci login: currSession 1 rpc gem processId 2824
successful login
topaz 1>printit
SystemRepository currentLogFile
%
/opt/gemstone/GemStone64Bit2.4.4.1-x86_64.Linux/seaside/data/tranlog4.dbf
topaz 1> printit
SystemRepository currentTranlogSizeMB
%
342
topaz 1> exit
Logging out session 1.
$
```


#### Example 2
```
topaz> set user DataCurator pass swordfish gems seaside
topaz> login
[07/02/11 03:10:58.557 UTC] gci login: currSession 1 rpc gem processId 2854
successful login
topaz 1> printit
SystemRepository class allSelectors
%
an Array
  #1 _idxForSortUndefinedObjectGreaterThanOrEqualToSelf:
  #2 asMultilineString
  #3 _idxForCompareEqualToDoubleByteString:
  #4 sorted:
  #5 _auditDependencyMap:
  #6 _asCollectionForSorting
  #7 loadVaryingFrom:
  #8 page
```

```
topaz 1> printit
System startCheckpointSync
%
true
topaz 1> printit                               
SystemRepository startNewLog
%
5
topaz 1> printit
SystemRepository currentLogFile
%
/opt/gemstone/GemStone64Bit2.4.4.1-x86_64.Linux/seaside/data/tranlog5.dbf
topaz 1> printit
SystemRepository currentTranlogSizeMB
%
topaz 1> printit
ObjectLogEntry emptyLog.
System commitTransaction
%
true
topaz 1> printit
SystemRepository markForCollection              
%
Successful completion of markForCollection.
    940988 live objects found.
    261985 possible dead objects, occupying approximately 23578650 bytes, may be reclaimed.
```

### Some tips from Dale

If the strings are not reaped by an MFC then given the oop of the String, you can look at it `Object _objectForOop: <oop>` and that might give you a clue as to it's source. You can use:

```smalltalk
SystemRepository findReferencePathToObject: (Object _objectForOop: <oop>)
```

 to find reference paths that keep the string alive ...

ScanBackup MFC  http://code.google.com/p/glassdb/issues/detail?id=136

```smalltalk
(KSSession allInstances
       select: [:each | each expired]) size
```

We then expired them all at the Seaside level:

```smalltalk
(KSSession allInstances do: [:each | each expire]
```

If objects are "possible dead" then the other gems et. al have the chance to veto the collection of objects. I would say it is unlikely that all of the 5.000.000 objects are not really dead. Do you know that markForCollection does just a "mark for collection"? It does not garbage collect the objects. Log out all of your DataCurator sessions and wait a few minutes. If things are normal you should see the empty space in the extent grow. If not, complain again.

```
topaz 1>run
SystemRepository markForCollection
%
topaz 1>run
SystemRepository postReclaimAll: SystemRepository reclaimAll
%
```

See section 6.6 ( step 3 ) of the system administration guide.


Ah yes, I forgot to mention the other effect - empty data pages .... over time the repository can have a fair number of completely empty data pages (as objects are changed the old data pages become "empty"). During normal operation these empty data pages take up space on disk.

A backup/restore cycle will completely eliminate the empty data pages, which can lead to dramatic reductions in repository size ...

Dale

```
topaz 1>printit
SystemRepository markForCollection
%
```

Free space:

```
topaz 1>printit
SystemRepository fileSizeReport
%
Extent #1
-----------
   Filename = !TCP@localhost#dir:/opt/gemstone/product/seaside/data#log://opt/gemstone/log/%N%P.log#dbf!/opt/gemstone/GemStone64Bit2.4.4.1-x86_64.Linux/seaside/data/extent0.dbf

   File size =       4990.00 Megabytes
   Space available = 4223.14 Megabytes

Totals
------
   Repository size = 4990.00 Megabytes
   Free Space =      4223.14 Megabytes
```

Just keeping the last 3-4 tranlog files will give you enough to recover from a crash.  This is what we do where I work, and to my knowledge theres never been any issues in almost 10yrs of operation

For crash recovery ... where the stone process crashes for some reason. You will need the set of tranlogs that were created since the last checkpoint. You can evaluate the following to find out the oldest tranlog that is needed to recover from the last checkpoint:

```smalltalk
SystemRepository oldestLogFileIdForRecovery
```


Depending upon the amount of disk space needed for the tranlogs during a restoreFromCurrentLogs you may want to look at the family of _ArchiveLog_ methods in the Repository class for additional recovery options.

* 9.4 How to Make a Smalltalk Full Backup
* 9.5 How to Restore from a Smalltalk Full Backup


### Clearing the object log
ObjectLogEntry is the key object:

```smalltalk
Object subclass: 'ObjectLogEntry'
	instVarNames: #( pid stamp label
	                  priority object tag)
	classVars: #( ObjectLog ObjectQueue)
	classInstVars: #()
	poolDictionaries: #[]
	inDictionary: ''
	category: 'Bootstrap-Gemstone'
```

There are two class side variables which seem to store the entries: `ObjectQueue` and `ObjectLog` and are accessed through the following class side methods:

```smalltalk
objectLog
	"expect the caller to abort, acquire lock, and commit if necessary"

	ObjectLog == nil ifTrue: [ ObjectLog := OrderedCollection new ].
	ObjectLog addAll: (self objectQueue _timeSortedComponents collect: [:ea | ea value]).
	self objectQueue removeAll.
	^ObjectLog
```

```smalltalk
objectQueue

	ObjectQueue == nil ifTrue: [ ObjectQueue := RcQueue new: 100 ].
	^ObjectQueue
```

```smalltalk
_objectLog
	"direct access to ObjectLog - should have acquired ObjectLogLock if removing entries from ObjectLog"

	ObjectLog == nil ifTrue: [ ObjectLog := OrderedCollection new ].
	^ObjectLog
```


So to see the size of the object Queue

```
printit
ObjectLogEntry _objectLog size
%
```

and:

```
printit
ObjectLogEntry objectQueue size
%
```

then to delete entries:

```
doit
System abortTransaction.
ObjectLogEntry acquireObjectLogLock.
ObjectLogEntry emptyLog.
System commitTransaction.
%
```

### Create a fresh extent

```bash
cp /opt/gemstone/product/bin/extent0.seaside.dbf \
  /opt/gemstone/product/seaside/data/extent0.dbf
chmod 644 /opt/gemstone/product/seaside/data/extent0.dbf
```
