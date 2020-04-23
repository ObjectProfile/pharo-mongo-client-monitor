Class {
	#name : #MCMTopologyEvent,
	#superclass : #MCMEvent,
	#instVars : [
		'topology'
	],
	#category : #'MongoClientMonitor-Core'
}

{ #category : #accessing }
MCMTopologyEvent >> topology [
	^ topology
]

{ #category : #accessing }
MCMTopologyEvent >> topology: anObject [
	topology := anObject
]
