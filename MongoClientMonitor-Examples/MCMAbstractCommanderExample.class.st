Class {
	#name : #MCMAbstractCommanderExample,
	#superclass : #Object,
	#instVars : [
		'recorder',
		'writeCommander',
		'readCommander',
		'client'
	],
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #'instance creation' }
MCMAbstractCommanderExample class >> defaultClient [
	| client |
	client := MongoClient withUrls: MongoReplicationTestResources allMongoUrls.
	client settings
		connectTimeout: 5 seconds;
		socketTimeout: 3 seconds;
		heartbeatFrequency: 3 seconds;
		maxConnections: 10;
		serverSelectionTimeout: 5 seconds.
	^ client
]

{ #category : #'instance creation' }
MCMAbstractCommanderExample class >> new [
	^ self newWith: self defaultClient
]

{ #category : #'instance creation' }
MCMAbstractCommanderExample class >> newWith: aMongoClient [
	^ self basicNew
		initializeWith: aMongoClient;
		yourself
]

{ #category : #accessing }
MCMAbstractCommanderExample >> addComment: aString with: aBlock [
	| aCommentEvent |
	aCommentEvent := MCMCommentEvent new
		comment: aString;
		startTimestamp: recorder timestampNow;
		yourself.
	aBlock ensure: [
		aCommentEvent endTimestamp: recorder timestampNow.
		recorder addEvent: aCommentEvent ]
]

{ #category : #examples }
MCMAbstractCommanderExample >> howToUse [
	"This method lists sentences that alter the status of the testing mongodb replica set."

	"Freeze server A and see how client adapts to the new replica set
	topology: B will become primary."
	MongoReplicationTestResources signalStopA.

	"Freeze also server B and see how the client adapts to the 
	new replica set topology: there is no primary to write now,
	but read operations show succeed in C."
	MongoReplicationTestResources signalStopB.

	"Unfreeze A and B and the client should return to initial state."
	MongoReplicationTestResources continueAllServers.

	"Something similar should happen if you stepDown servers (check
	the Mongo>>replicaSetStepDown: for more details on this operation."
	MongoReplicationTestResources stepDownA: 30 seconds.
	MongoReplicationTestResources stepDownB: 30 seconds.
]

{ #category : #accessing }
MCMAbstractCommanderExample >> initializeWith: aMongoClient [
	self initialize.

	client := aMongoClient.
	recorder := MCMRecorder newFor: client.
	writeCommander := MCMWriteCommander newFor: recorder.
	readCommander := MCMReadCommander newFor: recorder
]

{ #category : #accessing }
MCMAbstractCommanderExample >> readCommander [
	^ readCommander
]

{ #category : #accessing }
MCMAbstractCommanderExample >> recorder [
	^ recorder
]

{ #category : #accessing }
MCMAbstractCommanderExample >> start [
	"Start example. Don't forget to #stop it."

	"Start recording"
	recorder start.

]

{ #category : #accessing }
MCMAbstractCommanderExample >> stop [ 
	"Tear down example"

	recorder stop.
]

{ #category : #accessing }
MCMAbstractCommanderExample >> writeCommander [
	^ writeCommander
]
