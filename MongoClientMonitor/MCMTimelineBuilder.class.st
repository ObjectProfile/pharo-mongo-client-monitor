Class {
	#name : #MCMTimelineBuilder,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'events',
		'shouldBuildForAnimation',
		'scale',
		'heartbeatHeights',
		'heartbeatBaseY',
		'colorByTopologyType',
		'serverColorScale',
		'commandHeights',
		'colorByCommandType',
		'slotHeight',
		'pulseHeight',
		'lineWidth',
		'lineColor'
	],
	#category : #'MongoClientMonitor-Roassal3'
}

{ #category : #visiting }
MCMTimelineBuilder >> addCommandLabels [

	colorByCommandType keys do: [ :type |
		| shape y color |
		y := commandHeights at: type.
		color := colorByCommandType at: type.
		shape := self labelFor: type asString yPosition: y.
		shape color: color.
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
			x := scale scale: each.
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
MCMTimelineBuilder >> boxFor: event yPosition: y height: h [
	| a b w |
	a := scale scale: event startTimestamp.
	b := scale scale: event endTimestamp.
	w := b - a.
	
	^ RSBox new
		width: w;
		height: h;
		position: (a+(w/2)) @ (y+(h/2));
		border: (RSBorder new color: lineColor; width: lineWidth; yourself);
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
		to: scale range last;
		onStepDo: [ :t |
			canvas camera position: t @ (r floatCenter y).
			canvas signalUpdate ].

	canvas camera scale: 2.

"	canvas inspect. canvas camera scale: canvas extent y / (r height + 40)"
]

{ #category : #accessing }
MCMTimelineBuilder >> events: aCollection [
	events := aCollection
]

{ #category : #initialization }
MCMTimelineBuilder >> initialize [
	super initialize.
	shouldBuildForAnimation := false.
	slotHeight := 20.
	pulseHeight := 16.
	lineWidth := 0.5.
	lineColor := Color black alpha: 0.6.
	heartbeatBaseY := slotHeight*2.
	colorByTopologyType := {
		MongoTopologyType unknown -> Color brown.
		MongoTopologyType replicaSetNoPrimary -> Color veryDarkGray.
		MongoTopologyType replicaSetWithPrimary -> Color veryLightGray.
		} asDictionary.
	serverColorScale := RSColorPalette diverging puor6.
	colorByCommandType := { 
		MCMWriteCommander new commandType -> (Color fromString: 'E7298A').
		MCMReadCommander new commandType -> (Color fromString: '386CB0').
		} asDictionary.
	commandHeights := { 
		MCMWriteCommander new commandType -> (slotHeight * 7).
		MCMReadCommander new commandType -> (slotHeight * 8).
		} asDictionary
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
		endPoint: 1000 @ yWithOffset;
		yourself
]

{ #category : #hooks }
MCMTimelineBuilder >> recordingDuration [
	| startMicroseconds endMicroseconds |
	self flag: #todo. "The duration should be answered by the events."

	startMicroseconds := scale domain first.
	endMicroseconds := scale domain last.
	^ ((endMicroseconds - startMicroseconds) / 1000) milliSeconds
]

{ #category : #private }
MCMTimelineBuilder >> refreshServersFrom: aMongoTopology [

	self flag: #todo. "Should support discovering new servers"
	heartbeatHeights ifNotNil: [ ^self ].

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

	| shape y color |
	y := commandHeights at: event type.
	color := colorByCommandType at: event type.
	shape := self boxFor: event yPosition: y height: pulseHeight.
	shape
		color: color;
		model: event.
	self container add: shape
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMHeartbeatEvent: event [

	| shape y |
	y := heartbeatHeights at: event urlString.
	shape := self boxFor: event yPosition: y height: pulseHeight.
	shape
		color: (serverColorScale scale: event urlString);
		model: event.
	self container add: shape
]

{ #category : #visiting }
MCMTimelineBuilder >> visitMCMRecordingEvent: event [
	
	| shape |
	"Create scale for all shapes in the visualization"
	self assert: scale isNil. "More than one recording in the collection is not yet implemented."
	scale := NSScale linear
		domain: {
			event startTimestamp.
			event endTimestamp };
		range: { 0. 1000 };
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
	
	shape := self boxFor: event yPosition: slotHeight height: pulseHeight.
	shape
		color: (colorByTopologyType at: event topology type);
		model: event topology.
	self container add: shape
]
