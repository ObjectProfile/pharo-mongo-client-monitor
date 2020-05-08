Class {
	#name : #MCMAbstractCommander,
	#superclass : #TKTService,
	#instVars : [
		'recorder',
		'errorClassesToRetry',
		'numberOfMaxRetries',
		'readPreference'
	],
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #'instance creation' }
MCMAbstractCommander class >> newFor: aMCMRecorder [
	^ self basicNew
		initializeWith: aMCMRecorder;
		yourself
]

{ #category : #examples }
MCMAbstractCommander class >> openInWindows [
	"Open windows to execute the example."

	<example>
	| aWorkspace contents |

	"Open (and clean) Transcript."
	Transcript open; clear.

	"Show the example script."
	contents := Character cr join: ((self class sourceCodeAt: #scriptCode) lines allButFirst: 2).
	aWorkspace := Smalltalk tools workspace openContents: contents.
	aWorkspace label: 'Example'.
	
	"Show the replica set scenario."
	contents := ('This example uses the replica set scenario explained in the class comment of ', MongoReplicationTestResources name, ':
	
', MongoReplicationTestResources comment) surroundedBy: '"'.
	aWorkspace := Smalltalk tools workspace openContents: contents.
	aWorkspace label: 'Replica Set Scenario'.
	

]

{ #category : #examples }
MCMAbstractCommander class >> scriptCode [
	| example |
	"Ensure the replica set scenario is ready to use."
	MongoReplicationTestResources waitTestingScenario.

	"Start client and see how read and write operations are logged
	regularly."
	example := MongoClientExample new. 
	example startClientAndLoopReadingAndWriting.

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

	"Stop the example."
	example stopClient.

]

{ #category : #private }
MCMAbstractCommander >> commandType [
	^ self subclassResponsibility
]

{ #category : #initialization }
MCMAbstractCommander >> initialize [
	super initialize.

	numberOfMaxRetries := 0.

	errorClassesToRetry := MongoServerSelectionTimeout, MongoCommandError, MongoQueryError, NetworkError, MongoWireProtocolError.

]

{ #category : #initialization }
MCMAbstractCommander >> initializeWith: aMCMRecorder [
	self initialize.
	recorder := aMCMRecorder
]

{ #category : #accessing }
MCMAbstractCommander >> name [
	^ self className, (self identityHash asString)
]

{ #category : #accessing }
MCMAbstractCommander >> numberOfMaxRetries [
	^ numberOfMaxRetries
]

{ #category : #accessing }
MCMAbstractCommander >> numberOfMaxRetries: anObject [
	numberOfMaxRetries := anObject
]

{ #category : #accessing }
MCMAbstractCommander >> readPreference [
	^ readPreference
]

{ #category : #accessing }
MCMAbstractCommander >> readPreference: aMongoReadPreference [
	readPreference := aMongoReadPreference
]

{ #category : #hooks }
MCMAbstractCommander >> runOn: mongo [
	^ self subclassResponsibility
]

{ #category : #private }
MCMAbstractCommander >> runWithAvailableRetries: aNumber [

	| anEvent |
	anEvent := MCMCommandEvent new.
	anEvent type: self commandType.
	anEvent startTimestamp: recorder timestampNow.
	recorder addEvent: anEvent.
	
	[	recorder client
			mongoDo: [ :mongo |
				anEvent serverSelectionDoneTimestamp: recorder timestampNow.
				anEvent urlString: mongo urlString.
				self runOn: mongo.
				anEvent endTimestamp: recorder timestampNow ]
			readPreference: readPreference.

	] on: errorClassesToRetry do: [ :anError |
		anEvent
			endTimestamp: recorder timestampNow;
			errorDescription: anError description.
		aNumber > 0 ifTrue: [
			anEvent retryCommand: (self runWithAvailableRetries: aNumber-1) ] ].

	^ anEvent
]

{ #category : #stepping }
MCMAbstractCommander >> stepService [
	self runWithAvailableRetries: numberOfMaxRetries
]
