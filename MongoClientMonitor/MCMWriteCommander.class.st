Class {
	#name : #MCMWriteCommander,
	#superclass : #MCMAbstractCommander,
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #private }
MCMWriteCommander >> commandType [
	^ 'write'
]

{ #category : #accessing }
MCMWriteCommander >> initialize [
	super initialize.
	readPreference := MongoReadPreference newPrimary
]

{ #category : #hooks }
MCMWriteCommander >> runOn: mongo [

	| aDatabase aCollection aDocument |
	aDatabase := mongo databaseNamed: 'x'.
	aCollection := aDatabase collectionAt: 'y'.
	aDocument := Dictionary new
		at: 'z1' put: 'z2';
		yourself.
	aCollection commandInsert: aDocument writeConcern: nil
]
