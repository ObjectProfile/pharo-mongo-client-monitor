"
I represent a read or write command on a MongoClient via one ofo the variants of the #mongoDo:* API that its provided.

A command has two steps: (1) the server selection where the MongoClient looks for a Mongo instance according to the parameters, and (2) the operation performed by the application (in the Mongo instance).
The user can send #hasDoneServerSelection and #serverSelectionDoneTimestamp to get information about it.

The #type is intended to hold a way to recognize what kind of command is this.

Additionally, a command that failed may be retried and #retryCommand is intended to link it.
"
Class {
	#name : #MCMCommandEvent,
	#superclass : #MCMServerEvent,
	#instVars : [
		'retryCommand',
		'type',
		'serverSelectionDoneTimestamp'
	],
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #testing }
MCMCommandEvent >> hasDoneServerSelection [
	^ serverSelectionDoneTimestamp notNil
]

{ #category : #printing }
MCMCommandEvent >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' type: ';
		print: type
]

{ #category : #accessing }
MCMCommandEvent >> retryCommand [
	^ retryCommand
]

{ #category : #accessing }
MCMCommandEvent >> retryCommand: aMCMCommand [ 
	retryCommand := aMCMCommand
]

{ #category : #accessing }
MCMCommandEvent >> serverSelectionDoneTimestamp [
	^ serverSelectionDoneTimestamp
]

{ #category : #accessing }
MCMCommandEvent >> serverSelectionDoneTimestamp: aMicrosecondClockValue [
	serverSelectionDoneTimestamp := aMicrosecondClockValue
]

{ #category : #accessing }
MCMCommandEvent >> type [
	^ type
]

{ #category : #accessing }
MCMCommandEvent >> type: anObject [ 
	type := anObject
]
