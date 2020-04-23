Class {
	#name : #MCMEvent,
	#superclass : #Object,
	#instVars : [
		'startTime',
		'endTime'
	],
	#category : #'MongoClientMonitor-Core'
}

{ #category : #visiting }
MCMEvent >> accept: aVisitor [
	^ aVisitor perform: ('visit', self className) asSymbol asMutator withArguments: { self }.
]

{ #category : #accessing }
MCMEvent >> endTimestamp [
	^ endTime
]

{ #category : #accessing }
MCMEvent >> endTimestamp: anObject [
	endTime := anObject
]

{ #category : #printing }
MCMEvent >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.

	startTime ifNotNil: [
		aStream
			nextPutAll: ' start: ';
			print: startTime ].
	endTime ifNotNil: [
		aStream
			nextPutAll: ' end: ';
			print: endTime ]
]

{ #category : #accessing }
MCMEvent >> startTimestamp [
	^ startTime
]

{ #category : #accessing }
MCMEvent >> startTimestamp: anObject [
	startTime := anObject
]

{ #category : #accessing }
MCMEvent >> totalMicroseconds [
	^ endTime - startTime
]
