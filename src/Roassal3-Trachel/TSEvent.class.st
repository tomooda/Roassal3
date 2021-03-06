"
TSEvent is the root of all the events handled by Trachel (and therefore Roassal).
"
Class {
	#name : #TSEvent,
	#superclass : #Announcement,
	#instVars : [
		'canvas',
		'morph',
		'shape'
	],
	#category : #'Roassal3-Trachel-Events'
}

{ #category : #accessing }
TSEvent >> canvas [
	^ canvas ifNil: [ canvas := shape canvas ].
]

{ #category : #accessing }
TSEvent >> canvas: aTrachelCanvas [
	"Set the Trachel canvas"
	canvas := aTrachelCanvas
]

{ #category : #accessing }
TSEvent >> morph [
	^ morph ifNil: [ ^ morph := self canvas morph ]
]

{ #category : #accessing }
TSEvent >> morph: aMorph [
	morph := aMorph
]

{ #category : #accessing }
TSEvent >> shape [
	^ shape
]

{ #category : #accessing }
TSEvent >> shape: aTrachelShape [
	shape := aTrachelShape
]

{ #category : #accessing }
TSEvent >> signalUpdate [
	morph notNil ifTrue: [ morph changed ]
	
]
