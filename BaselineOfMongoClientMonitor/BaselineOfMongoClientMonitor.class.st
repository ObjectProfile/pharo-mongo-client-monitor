Class {
	#name : #BaselineOfMongoClientMonitor,
	#superclass : #BaselineOf,
	#category : #BaselineOfMongoClientMonitor
}

{ #category : #baseline }
BaselineOfMongoClientMonitor >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			self
				declareMongoClientOn: spec;
				declareRoassal3On: spec;
				declareTaskItOn: spec;
				declareTealightOn: spec.
			spec
				package: 'MongoClientMonitor-Core';
				package: 'MongoClientMonitor-Examples'
					with: [ spec requires: #('MongoClientMonitor-Core' 'TaskIt') ];
				package: 'MongoClientMonitor-Roassal3'
					with: [ spec requires: #('MongoClientMonitor-Examples' 'Roassal3') ];
				package: 'MongoClientMonitor-Tests'
					with: [ spec
						requires: #('MongoClientMonitor-Core' 'MongoClientMonitor-Examples') ] ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareMongoClientOn: spec [
	spec
		baseline: 'MongoClient'
		with: [
			spec
				repository: 'github://tinchodias/mongotalk:features-sdam2/mc';
				loads: 'SDAM' ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareRoassal3On: spec [
	spec
		baseline: 'Roassal3'
		with: [ spec repository: 'github://ObjectProfile/Roassal3:master/mc' ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareTaskItOn: spec [
	spec
		baseline: 'TaskIt'
		with: [ spec repository: '' ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareTealightOn: spec [
	spec
		baseline: 'Tealight'
		with: [ spec repository: 'github://astares/Tealight/repository' ]
]
