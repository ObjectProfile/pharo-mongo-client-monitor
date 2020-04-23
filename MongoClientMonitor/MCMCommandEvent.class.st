Class {
	#name : #MCMCommandEvent,
	#superclass : #MCMServerEvent,
	#instVars : [
		'serverSelectionDoneTime',
		'retryCommand',
		'type'
	],
	#category : #'MongoClientMonitor-Core'
}

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
MCMCommandEvent >> serverSelectionDoneTime [
	^ serverSelectionDoneTime
]

{ #category : #accessing }
MCMCommandEvent >> serverSelectionDoneTime: anObject [
	serverSelectionDoneTime := anObject
]

{ #category : #accessing }
MCMCommandEvent >> type [
	^ type
]

{ #category : #accessing }
MCMCommandEvent >> type: aClass [ 
	type := aClass
]
