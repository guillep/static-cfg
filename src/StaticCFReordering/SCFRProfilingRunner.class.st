Class {
	#name : #SCFRProfilingRunner,
	#superclass : #SMarkRunner,
	#category : #StaticCFReordering
}

{ #category : #'as yet unclassified' }
SCFRProfilingRunner class >> runBenchmarkNamed: benchname [
	
	| substrings selector runner wait |
	
	Stdio stdout nextPutAll: 'Profiling benchmark: ', benchname; crlf.
	
	substrings := benchname substrings: '>>#'.
	selector := substrings second asSymbol.

	wait := Semaphore new.
	[runner := self
		execute: (substrings first asClass new runOnly: selector)
		problemSize: 1.
		wait signal.] forkAt: 70.
	wait wait.
	^ (runner results at: (SMarkSuite new benchmarkNameForSelector: selector)) first
]

{ #category : #'as yet unclassified' }
SCFRProfilingRunner class >> runOnFile: aFileName [

	| results |
	results := Dictionary new.
	aFileName asFileReference readStreamDo: [ :e | | line |
		"skip title"
		e nextLine.
		
		[ (line := e nextLine) isNil ] whileFalse: [ | benchname |
			benchname := line substrings first.
			results at: benchname put: (self runBenchmarkNamed: benchname).
		] ].

	STONJSON put: results onStream: 'characterisation.json'
]

{ #category : #running }
SCFRProfilingRunner >> primitiveStartProfiling [

	<primitive: 65>
	self primitiveFailed
]

{ #category : #running }
SCFRProfilingRunner >> primitiveStopProfiling [

	<primitive: 66>
	self primitiveFailed
]

{ #category : #running }
SCFRProfilingRunner >> timedBenchmarkExecution: aSelector [

	| result profilerResult massagedResult |
	[ 
	self primitiveStartProfiling.
	result := suite perform: aSelector ] ensure: [ 
		profilerResult := self primitiveStopProfiling ].
	
	massagedResult := Dictionary new.
	massagedResult at: 'implicitJumpsFound' put: profilerResult first.
	massagedResult at: 'implicitJumpsTaken' put: profilerResult second.
	
	
	profilerResult := profilerResult third.
	profilerResult := (OrderedCollection streamContents: [ :str |
    [ profilerResult first notNil ] whileTrue: [
        str nextPut: profilerResult first name.
        profilerResult := profilerResult second.
    ]
]) asBag asDictionary.
	
	massagedResult at: 'methodsExecuted' put: profilerResult.
	(results
		at: (suite benchmarkNameForSelector: aSelector)
		ifAbsentPut: [OrderedCollection new]) add: massagedResult.
]
