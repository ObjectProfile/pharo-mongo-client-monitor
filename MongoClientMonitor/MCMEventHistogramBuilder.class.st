Class {
	#name : #MCMEventHistogramBuilder,
	#superclass : #Object,
	#instVars : [
		'events',
		'totalMicroseconds',
		'x',
		'histogramRanges',
		'histogramCounts'
	],
	#category : #'MongoClientMonitor-Roassal3'
}

{ #category : #accessing }
MCMEventHistogramBuilder >> events: aCollection [ 
	events := aCollection
]

{ #category : #private }
MCMEventHistogramBuilder >> indexOfIntervalFor: each [
	histogramRanges
		doWithIndex: [ :interval :index | 
			(interval rangeIncludes: each)
				ifTrue: [ index traceCr.
					^ index ] ].
	self error
]

{ #category : #hooks }
MCMEventHistogramBuilder >> newChart [
	| chart p |
	totalMicroseconds := events collect: [ :event | event totalMicroseconds log ].
	x := 0 to: totalMicroseconds max count: 20.
	histogramRanges := x overlappingPairsCollect: [ :a :b | a to: b ].

	histogramCounts := Array new: histogramRanges size withAll: 0.
	totalMicroseconds do: [ :each |
		| intervalIndex |
		intervalIndex := self indexOfIntervalFor: each.
		histogramCounts at: intervalIndex put: (histogramCounts at: intervalIndex)+1 ].
	
	p := RSBarPlot new x: x allButFirst y: histogramCounts.
	p barWidth: 10.

	chart := RSChart new
		xlabel: 'duration time';
		ylabel: '# events';
		title: 'Histogram';
		yourself.

	chart addPlot: p.
	^ chart


	"	lg := RSLabelGenerator nice: RSNiceStepSizeGenerator new.
	lg setLooseFlag: true.
	label := lg searchMin: 0 max: max desired: 12.
	label min to: label max by: label step do: [ :each | ]."
]
