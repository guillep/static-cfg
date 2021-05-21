Class {
	#name : #BaselineOfStaticCFReordering,
	#superclass : #BaselineOf,
	#category : #BaselineOfStaticCFReordering
}

{ #category : #baselines }
BaselineOfStaticCFReordering >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		spec 
			baseline: 'Benchmarks' 
			with: [ 
				spec repository: 'github://pharo-project/pharo-benchmarks/src' ] ]
]
