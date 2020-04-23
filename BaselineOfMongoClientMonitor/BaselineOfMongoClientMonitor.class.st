Class {
	#name : #BaselineOfMongoClientMonitor,
	#superclass : #BaselineOf,
	#category : #BaselineOfMongoClientMonitor
}

{ #category : #baseline }
BaselineOfMongoClientMonitor >> addMongoClient: spec [
	spec
		baseline: 'MongoClient'
		with: [
			spec
				repository: 'github://tinchodias/mongotalk:features-sdam2/mc';
				loads: 'SDAM' ]
]

{ #category : #baseline }
BaselineOfMongoClientMonitor >> addRoassal3: spec [
	spec
		baseline: 'Roassal3'
		with: [ spec repository: 'github://ObjectProfile/Roassal3:master/mc' ]
]

{ #category : #baseline }
BaselineOfMongoClientMonitor >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self addMongoClient: spec.
			self addRoassal3: spec.
			spec
				package: 'MongoClientMonitor'
				with: [ spec requires: #(MongoClient Roassal3) ] ]
]
