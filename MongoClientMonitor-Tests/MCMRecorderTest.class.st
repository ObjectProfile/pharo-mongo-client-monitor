"
A MCMRunnerTest is a test class for testing the behavior of MCMRunner
"
Class {
	#name : #MCMRecorderTest,
	#superclass : #TestCase,
	#instVars : [
		'heartbeatFrequency',
		'recorder',
		'writeCommander',
		'readCommander',
		'client'
	],
	#category : #'MongoClientMonitor-Tests'
}

{ #category : #tests }
MCMRecorderTest >> defaultTimeLimit [
	^ 1 minute
]

{ #category : #running }
MCMRecorderTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	"Ensure the replica set scenario is ready to use."
	MongoReplicationTestResources waitTestingScenario.

	heartbeatFrequency := 3 seconds.

	client := MongoClient withUrls: MongoReplicationTestResources allMongoUrls.
	client settings
		connectTimeout: 5 seconds;
		socketTimeout: 5 seconds;
		heartbeatFrequency: heartbeatFrequency.

	recorder := MCMRecorder newFor: client.
	recorder start.

	writeCommander := (MCMWriteCommander newFor: recorder)
		stepDelay: 1 second;
		start;
		yourself.
	
	readCommander := (MCMReadCommander newFor: recorder)
		stepDelay: 1 second;
		start;
		yourself.

]

{ #category : #tests }
MCMRecorderTest >> tearDown [
	writeCommander stop.
	readCommander stop.
	recorder stop.

	super tearDown
]

{ #category : #tests }
MCMRecorderTest >> testChangingPrimaryScenario [
	| events heartbeats commands |
	heartbeatFrequency wait.
	MongoReplicationTestResources signalStopA.
	heartbeatFrequency wait.

	events := recorder events contents.
	heartbeats := events select: [ :each | each isKindOf: MCMHeartbeatEvent ].
	commands := events select: [ :each | each isKindOf: MCMCommandEvent  ].

	self assert: heartbeats size >= (2 * client topology numberOfServers).
	self assert: commands notEmpty. 

]

{ #category : #tests }
MCMRecorderTest >> testIdealScenario [
	| events heartbeats commands |
	heartbeatFrequency wait.

	events := recorder events contents.
	heartbeats := events select: [ :each | each isKindOf: MCMHeartbeatEvent ].
	commands := events select: [ :each | each isKindOf: MCMCommandEvent  ].

	self assert: heartbeats size >= client topology numberOfServers.
	self assert: commands notEmpty. 

]
