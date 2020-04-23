Class {
	#name : #MCMServerEvent,
	#superclass : #MCMEvent,
	#instVars : [
		'urlString',
		'errorDescription'
	],
	#category : #'MongoClientMonitor-Core'
}

{ #category : #accessing }
MCMServerEvent >> errorDescription [
	^ errorDescription ifNil: [ '' ]
]

{ #category : #accessing }
MCMServerEvent >> errorDescription: anObject [
	errorDescription := anObject
]

{ #category : #testing }
MCMServerEvent >> isSuccess [
	^ errorDescription isNil
]

{ #category : #printing }
MCMServerEvent >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' urlString: ';
		print: urlString.
	self isSuccess
		ifFalse: [ aStream nextPutAll: ' FAILED ' ]
]

{ #category : #accessing }
MCMServerEvent >> urlString [
	^ urlString
]

{ #category : #accessing }
MCMServerEvent >> urlString: anObject [
	urlString := anObject
]
