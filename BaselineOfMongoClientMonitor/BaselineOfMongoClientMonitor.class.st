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
				declareMongoTalkOn: spec;
				declareRoassal3On: spec;
"				declareTaskItOn: spec;"
				declareTealightOn: spec.
			spec
				package: 'MongoClientMonitor-Core'
					with: [ spec requires: #('MongoTalk') ];
				package: 'MongoClientMonitor-Examples'
					with: [ spec requires: #('MongoClientMonitor-Core' "'TaskIt'") ];
				package: 'MongoClientMonitor-Roassal3'
					with: [ spec requires: #('MongoClientMonitor-Examples' 'Roassal3') ];
				package: 'MongoClientMonitor-Tests'
					with: [ spec requires: #(
						'MongoClientMonitor-Core'
						'MongoClientMonitor-Examples') ] ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareMongoTalkOn: spec [
	spec
		baseline: 'MongoTalk'
		with: [
			spec
				repository: 'github://pharo-nosql/mongotalk:master/mc';
				loads: 'Client' ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareRoassal3On: spec [
	spec
		baseline: 'Roassal3'
		with: [ spec repository: 'github://ObjectProfile/Roassal3:master/src' ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareTaskItOn: spec [
	spec
		baseline: 'TaskIt'
		with: [ spec repository: 'github://sbragagnolo/taskit:master' ]
]

{ #category : #'external projects' }
BaselineOfMongoClientMonitor >> declareTealightOn: spec [
	spec
		baseline: 'Tealight'
		with: [ spec repository: 'github://astares/Tealight:master/repository' ]
]
