Class {
	#name : #MCMAutonomousExample,
	#superclass : #MCMAbstractCommanderExample,
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #accessing }
MCMAutonomousExample >> start [
	"Start example. Don't forget to #stop it."

	super start.
	self startCommanders
]

{ #category : #accessing }
MCMAutonomousExample >> startCommanders [
	writeCommander
		stepDelay: 50 milliseconds;
		start.
	readCommander
		stepDelay: 50 milliseconds;
		start
]

{ #category : #accessing }
MCMAutonomousExample >> stop [
	self stopCommanders.
	super stop.

]

{ #category : #accessing }
MCMAutonomousExample >> stopCommanders [
	writeCommander stop waitForCompletion: 9 seconds.
	readCommander stop waitForCompletion: 9 seconds.
]
