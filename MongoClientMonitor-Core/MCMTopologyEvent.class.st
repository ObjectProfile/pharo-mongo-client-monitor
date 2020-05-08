"
I represent a change in the topology of a MongoClient.
"
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
MCMTopologyEvent >> topology: aMongoClientTopology [
	topology := aMongoClientTopology
]
