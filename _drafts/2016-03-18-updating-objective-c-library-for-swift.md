---
layout: post
title: "objective-c <=> swift interop - down the rabbit holeUpdating an Objective-C library for Swift"
date: 2016-03-18
excerpt_separator: <!--more-->
---
Recently I updated an Objective-C library for improved Swift interoperability. The Objective-C library hadn't been touched for a while - it still used manually memory management rather than ARC. The library's use of manual memory management added additional challenges that I thought would be worthwhile documenting.

## Initial Swift interface

How it imported originally.

public func diff_mainOfOldString(text1: String!, andNewString text2: String!) -> NSMutableArray!

func test() {

let differ = DiffMatchPatch();
let diffs =  differ.diff_mainOfOldString("hello world", andNewString: "goodbye world")

}


Modernised Objective-C by:
1) Running the “Convert to modern Objective-C syntax” tool, which:
   * converted NSArray indexing to use the `[]` syntax
   * converted boxed literals to use the `@()` syntax
   * favours dot syntax over square brackets
   * converted `id` to `instancetype` on `init..` methods
2) Manually converted to use automatic synthesis of properties; removed
the instance variables backing store and checked access to the instance
variables to go through the property e.g. `Diff_EditCost` becomes
`self.Diff_EditCost`
3) Added array annotations to help with Swift interop
4) Wrapped in the header in `NS_ASSUME_NONNULL_BEGIN` …
`NS_ASSUME_NONNULL_END` again to aid Swift interop
5) Fixed some memory leaks caused by methods returning core-foundation
objects (`CFArrayxxx`, `CFStringxxx`) with a +1 retain count; changed
`__bridge` to `CFBridgingRelease`


ded Objective-C array generic parameterisation for improved Swift
interop.

However to import the `DiffMatchPatch` API cleanly into Swift required
changing API methods to return `NSArray` rather than `NSMutableArray`.

Returning `NSArray` as opposed to `NSMutableArray` required some
massaging of `NSArray` -> `NSMutableArray` within methods.

However the following methods changes their semantics; changing from:
`- (void)diff_cleanupSemantic:(NSMutableArray *)diffs;`
`- (void)diff_cleanupSemanticLossless:(NSMutableArray *)diffs;`
`- (void)diff_cleanupEfficiency:(NSMutableArray *)diffs;`
`- (void)diff_cleanupMerge:(NSMutableArray *)diffs;`
`- (void)patch_splitMax:(NSMutableArray *)patches;`

to:

`- (NSArray<Diff *> *)diff_cleanupSemantic:(NSArray<Diff *> *)diffs;`
`- (NSArray<Diff *> *)diff_cleanupSemanticLossless:(NSArray<Diff *>
*)diffs;`
`- (NSArray<Diff *> *)diff_cleanupEfficiency:(NSArray<Diff *> *)diffs;`
`- (NSArray<Diff *> *)diff_cleanupMerge:(NSArray<Diff *> *)diffs;`
`- (NSArray<Patch *> *)patch_splitMax:(NSArray<Patch *>
*)immutablePatches;`

That is rather than manipulating an `NSMutableArray` parameter, the
methods return the changed array.

I hope that not only is the Swift interop beneficial, but a valuable
side-effect is an improved API - cleaning up the bad practice of
returning mutable collections from API methods.


added .travis.yml and README.md



Why did I have to make it ARC compilant? Answer: ARC enabled so that I could make diff NS_ASSUME_NONNULL_BEGIN - that didn't work in the case of pre-ARC code. Changed interfaces for NSMutatableArray to NSArray to map directly to Swift Array
