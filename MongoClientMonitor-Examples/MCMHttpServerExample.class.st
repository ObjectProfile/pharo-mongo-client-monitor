Class {
	#name : #MCMHttpServerExample,
	#superclass : #MCMAbstractCommanderExample,
	#instVars : [
		'teapot'
	],
	#category : #'MongoClientMonitor-Examples'
}

{ #category : #accessing }
MCMHttpServerExample >> doRead [
	readCommander stepService.
	^ 'done'
]

{ #category : #accessing }
MCMHttpServerExample >> doWrite [
	writeCommander stepService.
	^ 'done'
]

{ #category : #accessing }
MCMHttpServerExample >> httpPortNumber [
	^ 8082
]

{ #category : #accessing }
MCMHttpServerExample >> start [
	"Start example. Don't forget to #stop it."

	super start.
	self startTeapot.
]

{ #category : #accessing }
MCMHttpServerExample >> startTeapot [
	"Start HTTP server"

	teapot := Teapot configure: {
		#port -> self httpPortNumber.
		#debugMode -> true }.
	teapot
	   GET: '/read' -> [ self doRead ];
	   GET: '/write' -> [ self doWrite ];
	   start.

]

{ #category : #accessing }
MCMHttpServerExample >> stop [ 
	"Tear down example"

	super stop.
	self stopTeapot.
]

{ #category : #accessing }
MCMHttpServerExample >> stopTeapot [
	teapot stop.
	teapot removeAllDynamicRoutes
]
