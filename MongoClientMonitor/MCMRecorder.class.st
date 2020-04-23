Class {
	#name : #MCMRecorder,
	#superclass : #Object,
	#instVars : [
		'client',
		'events',
		'recordingEvent',
		'rawAnnouncements',
		'topologyEvent',
		'ongoingHeartbeatEvents'
	],
	#category : #'MongoClientMonitor-Core'
}

{ #category : #'instance creation' }
MCMRecorder class >> newFor: aMongoClient [
	^ self basicNew
		initializeWith: aMongoClient;
		yourself
]

{ #category : #private }
MCMRecorder >> addEvent: anEvent [
	events nextPut: anEvent
]

{ #category : #accessing }
MCMRecorder >> client [
	^ client
]

{ #category : #accessing }
MCMRecorder >> events [
	^ events
]

{ #category : #initialization }
MCMRecorder >> initializeWith: aMongoClient [
	self initialize.
	
	client := aMongoClient.
	self subscribeToClient.

	events := SharedQueue new.
	ongoingHeartbeatEvents := SharedQueue new.
	rawAnnouncements := SharedQueue new.

]

{ #category : #private }
MCMRecorder >> popHeartbeatEventFor: aUrlString [
	^ ongoingHeartbeatEvents nextOrNilSuchThat: [ :each |
			each urlString = aUrlString ]
]

{ #category : #'processing announcements' }
MCMRecorder >> processHeartbeatFailed: aMongoHeartbeatFailed [

	rawAnnouncements nextPut: aMongoHeartbeatFailed.

	(self popHeartbeatEventFor: aMongoHeartbeatFailed urlString)
		endTimestamp: aMongoHeartbeatFailed microsecondTimestamp;
		errorDescription: aMongoHeartbeatFailed errorDescription

]

{ #category : #'processing announcements' }
MCMRecorder >> processHeartbeatStarted: aMongoHeartbeatStarted [
	| heartbeat |
	rawAnnouncements nextPut: aMongoHeartbeatStarted.

	heartbeat := MCMHeartbeatEvent new
		startTimestamp: aMongoHeartbeatStarted microsecondTimestamp;
		urlString: aMongoHeartbeatStarted urlString;
		yourself.
	ongoingHeartbeatEvents nextPut: heartbeat.
	self addEvent: heartbeat
]

{ #category : #'processing announcements' }
MCMRecorder >> processHeartbeatSucceeded: aMongoHeartbeatSucceeded [

	rawAnnouncements nextPut: aMongoHeartbeatSucceeded.

	(self popHeartbeatEventFor: aMongoHeartbeatSucceeded urlString)
		endTimestamp: aMongoHeartbeatSucceeded microsecondTimestamp
]

{ #category : #'processing announcements' }
MCMRecorder >> processTopologyUpdate: aMongoTopologyUpdate [
	rawAnnouncements nextPut: aMongoTopologyUpdate.

	self startTopology: aMongoTopologyUpdate newTopology.
]

{ #category : #starting }
MCMRecorder >> start [
	self assert: recordingEvent isNil.
	recordingEvent := MCMRecordingEvent new.
	recordingEvent startTimestamp: self timestampNow.
	self addEvent: recordingEvent.
	
	self startTopology: client topology.

	client start.

]

{ #category : #private }
MCMRecorder >> startTopology: aMongoTopology [ 

	| now |
	now := self timestampNow.

	"The first time after start there is no previous topology"
	topologyEvent ifNotNil: [
		topologyEvent endTimestamp: now ].

	topologyEvent := MCMTopologyEvent new
		startTimestamp: now;
		topology: aMongoTopology;
		yourself.
	self addEvent: topologyEvent.
]

{ #category : #starting }
MCMRecorder >> stop [
	client stop.
	
	recordingEvent ifNotNil: [
		recordingEvent endTimestamp: self timestampNow.
		recordingEvent := nil ].
	topologyEvent ifNotNil: [
		topologyEvent endTimestamp: self timestampNow.
		topologyEvent := nil ].

]

{ #category : #initialization }
MCMRecorder >> subscribeToClient [
	{	MongoHeartbeatStarted -> #processHeartbeatStarted:.
		MongoHeartbeatSucceeded -> #processHeartbeatSucceeded:.
		MongoHeartbeatFailed -> #processHeartbeatFailed:.
		MongoTopologyUpdate -> #processTopologyUpdate:.
		} 	do: [ :each |
				client announcer weak
					when: each key
					send: each value
					to: self ]

]

{ #category : #accessing }
MCMRecorder >> timestampNow [
	^ Time microsecondClockValue
]
