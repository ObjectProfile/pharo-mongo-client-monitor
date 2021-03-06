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
		stepDelay: 25 milliseconds;
		start.
	readCommander
		stepDelay: 25 milliseconds;
		start
]

{ #category : #accessing }
MCMAutonomousExample >> stop [
	self stopCommanders.
	super stop.

]

{ #category : #accessing }
MCMAutonomousExample >> stopCommanders [
	writeCommander stop waitForCompletion: 1 second.
	readCommander stop waitForCompletion: 1 second.
]
