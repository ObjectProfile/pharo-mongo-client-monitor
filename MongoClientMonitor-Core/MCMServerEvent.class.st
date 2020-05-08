"
I represent an event that happened in a MongoDB server. 

Since the MongoClient connects wo the server via Socket, every event may be a success (#isSuccess) or a failure.

"
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
MCMServerEvent >> errorDescription: aString [
	errorDescription := aString
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
MCMServerEvent >> urlString: aString [
	urlString := aString
]
