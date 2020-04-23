Class {
	#name : #MCMReadCommander,
	#superclass : #MCMAbstractCommander,
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #private }
MCMReadCommander >> commandType [
	^ 'read'
]

{ #category : #accessing }
MCMReadCommander >> initialize [
	super initialize.
	readPreference := MongoReadPreference newPrimaryPreferred
		maxStaleness: 90 seconds;
		yourself
]

{ #category : #hooks }
MCMReadCommander >> runOn: mongo [

	| aDatabase aCollection |
	aDatabase := mongo databaseNamed: 'x'.
	aCollection := aDatabase collectionAt: 'y'.
	(aCollection commandFind: Dictionary new limit: 0 readConcern: nil)
		setFlagSlaveOk;
		contents
]
