"
I build Roassal3 canvas with the timeline MCMEvents provided by a MCMRecorder.

Example:
-----

""Ensure the replica set scenario is ready to use.""
MongoReplicationTestResources waitTestingScenario.

example := MCMAutonomousExample new.
example start.
5 seconds wait.
example addComment: 'SIGSTOP A' with: [ 
	MongoReplicationTestResources signalStopA ].
5 seconds wait.
example addComment: 'SIGSTOP B' with: [ 
	MongoReplicationTestResources signalStopB ].
10 seconds wait.
example addComment: 'SIGCONT *' with: [ 
	MongoReplicationTestResources continueAllServers ].
12 seconds wait.
example stop.

events := example recorder events contents.

canvas := MCMTimelineBuilder new
	events: events;
	shouldBuildForAnimation: false;
	build;
	canvas.
	
canvas inspect.

----
"
Class {
	#name : #MCMTimelineBuilder,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'events',
		'shouldBuildForAnimation',
		'heartbeatHeights',
		'heartbeatBaseY',
		'serverColorScale',
		'commandHeights',
		'slotHeight',
		'pulseHeight',
		'lineWidth',
		'lineColor',
		'timeScale',
		'commentLabelInteraction'
	],
	#category : #'MongoClientMonitor-Roassal3'
}

{ #category : #visiting }
MCMTimelineBuilder >> addCommandLabels [

	commandHeights keysDo: [ :type |
		| shape y |
		y := commandHeights at: type.
		shape := self labelFor: type asString yPosition: y.
		self container add: shape.
		
		self container add: (self pulseRailAtY: y) ]
]

{ #category : #visiting }
MCMTimelineBuilder >> addHeartbeatLabelsFor: aMongoTopology [

	aMongoTopology serversUrlStrings do: [ :each |
		| shape y |
		y := heartbeatHeights at: each.
		shape := self labelFor: each yPosition: y.
		shape color: (serverColorScale scale: each).
		self container add: shape.
		
		self container add: (self pulseRailAtY: y).
		]
]

{ #category : #visiting }
MCMTimelineBuilder >> addTimeTicks: event [
	| timeTickStep |
	timeTickStep := 250 milliseconds asMicroseconds.
	(event startTimestamp to: event endTimestamp by: timeTickStep)
		withIndexDo: [ :each :index | 
			| x color shape |
			x := timeScale scale: each.
			color := index \\ 4 = 1
				ifTrue: [ lineColor alpha: 0.3 ]
				ifFalse: [ lineColor alpha: 0.1 ].
			shape := RSLine new
				color: color;
				width: lineWidth;
				dashArray: #(0.5);
				startPoint: x @ 0;
				endPoint: x @ 200;
				yourself.
			self container add: shape ].
		
	
			"	lg := RSLabelGenerator nice: RSNiceStepSizeGenerator new.
	lg setLooseFlag: true.
	label := lg searchMin: 0 max: event endTimestamp desired: (event ).
	label min to: label max by: label step do: [ :each |
		self container add: shape ].
"

]

{ #category : #visiting }
MCMTimelineBuilder >> addTopologyLabel [
	| shape |
	shape := self labelFor: 'topology' yPosition: slotHeight.
	self container add: shape
]

{ #category : #private }
MCMTimelineBuilder >> boxFor: event yPosition: y height: h color: aColor [
	| a b w borderColor |
	a := timeScale scale: event startTimestamp.
	b := timeScale scale: event endTimestamp.
	w := b - a.
	borderColor := aColor mixed: 70 percent with: lineColor.
	
	^ RSBox new
		width: w;
		height: h;
		position: (a+(w/2)) @ (y+(h/2));
		color: aColor;
		border: (RSBorder new color: borderColor; width: lineWidth; yourself);
		popup;
		draggable;
		yourself
]

{ #category : #hooks }
MCMTimelineBuilder >> buildForAnimation [
	| r canvas |
	canvas := self container.
	r := canvas encompassingRectangle.
	canvas newAnimation
		duration: self recordingDuration;
		from: 0; 
		to: timeScale range last;
		onStepDo: [ :t |
			canvas camera position: t @ (r floatCenter y).
			canvas signalUpdate ].

	canvas camera scale: 2.

"	canvas inspect. canvas camera scale: canvas extent y / (r height + 40)"
]

{ #category : #private }
MCMTimelineBuilder >> colorForTopology: aMongoTopology [
	^ aMongoTopology isTypeReplicaSetWithPrimary
		ifTrue: [ serverColorScale scale: aMongoTopology primaryUrlString ]
		ifFalse: [
			aMongoTopology isTypeReplicaSetNoPrimary
				ifTrue: [ Color veryDarkGray ]
				ifFalse: [ Color white ] ]
]

{ #category : #accessing }
MCMTimelineBuilder >> events: aCollection [
	events := aCollection
]

{ #category : #initialization }
MCMTimelineBuilder >> initialize [
	super initialize.
	shouldBuildForAnimation := false.
	slotHeight := 18.
	pulseHeight := 14.
	lineWidth := 0.5.
	lineColor := Color black alpha: 0.6.
	heartbeatBaseY := slotHeight * 2.
	serverColorScale := RSColorPalette qualitative dark27.
	commandHeights := { 
		MCMWriteCommander new commandType -> (slotHeight * 7).
		MCMReadCommander new commandType -> (slotHeight * 8).
		} asDictionary.
	
	commentLabelInteraction := RSLabeled new.
	commentLabelInteraction location offset: 0@(pulseHeight / -2).
	commentLabelInteraction text: [ :model | model comment ].
]

{ #category : #private }
MCMTimelineBuilder >> labelFor: aString yPosition: y [ 
	
	| label h w x |
	label := RSLabel new
		fontSize: 8;
		text: aString
		yourself.

	h := label textHeight.
	w := label textWidth.
	x := -5.

	label position: ((x-(w/2)) @ (y+(h/2))).
	
	^ label
]

{ #category : #visiting }
MCMTimelineBuilder >> pulseRailAtY: y [
	| yWithOffset |
	yWithOffset := y + (pulseHeight/2).
	^ RSLine new
		width: lineWidth;
		color: lineColor;
		dashArray: #(2);
		startPoint: -3 @ yWithOffset;
		endPoint: timeScale range last @ yWithOffset;
		yourself
]

{ #category : #hooks }
MCMTimelineBuilder >> recordingDuration [
	| startMicroseconds endMicroseconds |
	self flag: #todo. "The duration should be answered by the events."

	startMicroseconds := timeScale domain first.
	endMicroseconds := timeScale domain last.
	^ ((endMicroseconds - startMicroseconds) / 1000) milliSeconds
]

{ #category : #private }
MCMTimelineBuilder >> refreshServersFrom: aMongoTopology [

	self flag: #todo. "Should support discovering new servers"
	heartbeatHeights ifNotNil: [ ^ self ].

	"Stablish the y for each server's heartbeat"
	heartbeatHeights := Dictionary new.
	aMongoTopology serversUrlStrings withIndexDo: [ :each :index |
		heartbeatHeights at: each put: heartbeatBaseY + (index * slotHeight) ].

	"Add labels"	
	self addHeartbeatLabelsFor: aMongoTopology.

]

{ #category : #hooks }
MCMTimelineBuilder >> renderIn: canvas [
	events do: [ :each | each accept: self ].

	shouldBuildForAnimation
		ifTrue: [ self buildForAnimation ]
		ifFalse: [ canvas addInteraction: RSCanvasController ]
]

{ #category : #accessing }
MCMTimelineBuilder >> shouldBuildForAnimation [
	^ shouldBuildForAnimation
]

{ #category : #accessing }
MCMTimelineBuilder >> shouldBuildForAnimation: anObject [
	shouldBuildForAnimation := anObject
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMCommandEvent: event [
	| shape color |
	color := event hasDoneServerSelection
		ifTrue: [ serverColorScale scale: event urlString ]
		ifFalse: [ Color veryLightGray ].
	shape := self
		boxFor: event
		yPosition: (commandHeights at: event type)
		height: pulseHeight
		color: color.
	shape model: event.
	self container add: shape
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMCommentEvent: event [ 
	| shape |
	shape := self
		boxFor: event
		yPosition: (-0.5* slotHeight)
		height: pulseHeight
		color: lineColor.
	shape model: event; addInteraction: commentLabelInteraction.
	self container add: shape
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMHeartbeatEvent: event [
	| shape |
	shape := self
		boxFor: event
		yPosition: (heartbeatHeights at: event urlString)
		height: pulseHeight
		color: (serverColorScale scale: event urlString).
	shape model: event.
	self container add: shape
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMRecordingEvent: event [
	
	"Create scale for all shapes in the visualization"
	self assert: timeScale isNil. "More than one recording in the collection is not yet implemented."
	timeScale := NSScale linear
		domain: {
			event startTimestamp.
			event endTimestamp };
		range: { 0. 2000 };
		yourself.

	"Create decorations"
	self addTopologyLabel.
	self addCommandLabels.
	self addTimeTicks: event.
	
	"Create a box to represent the total recording time"
"	shape := self boxFor: event yPosition: -1*pulseHeight height: pulseHeight.
	shape
		color: Color transparent;
		model: event.
	self container add: shape"
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMTopologyEvent: event [
	| shape |
	self refreshServersFrom: event topology.
	shape := self
		boxFor: event
		yPosition: slotHeight
		height: pulseHeight
		color: (self colorForTopology: event topology).
	shape model: event topology.
	self container add: shape
]
