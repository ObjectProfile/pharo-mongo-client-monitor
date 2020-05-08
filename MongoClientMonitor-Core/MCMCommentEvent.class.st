"
I represent a comment, useful to annotate a recording.
"
Class {
	#name : #MCMCommentEvent,
	#superclass : #MCMEvent,
	#instVars : [
		'comment'
	],
	#category : #'MongoClientMonitor-Core'
}

{ #category : #accessing }
MCMCommentEvent >> comment [
	^ comment
]

{ #category : #accessing }
MCMCommentEvent >> comment: aString [
	comment := aString
]

{ #category : #printing }
MCMCommentEvent >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' comment: ';
		print: comment.
]
