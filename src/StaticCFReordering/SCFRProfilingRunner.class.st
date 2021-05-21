Class {
	#name : #SCFRProfilingRunner,
	#superclass : #SMarkRunner,
	#category : #StaticCFReordering
}

{ #category : #'as yet unclassified' }
SCFRProfilingRunner class >> runBenchmarkNamed: benchname [
	
	| substrings selector runner |
	
	Stdio stdout nextPutAll: 'Profiling benchmark: ', benchname; crlf.
	
	substrings := benchname substrings: '>>#'.
	selector := substrings second asSymbol.
	
	[runner := self
		execute: (substrings first asClass new runOnly: selector)
		problemSize: 1] forkAt: 70.
		
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

	| result profilerResult |
	[ 
	self primitiveStartProfiling.
	result := suite perform: aSelector ] ensure: [ 
		profilerResult := self primitiveStopProfiling ].
	
	profilerResult := (OrderedCollection streamContents: [ :str |
    [ profilerResult first notNil ] whileTrue: [
        str nextPut: profilerResult first name.
        profilerResult := profilerResult second.
    ]
]) asSet asArray.
	
	(results
		at: (suite benchmarkNameForSelector: aSelector)
		ifAbsentPut: [OrderedCollection new]) add: profilerResult.
]
