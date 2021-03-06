"
I describe a command for RSAbstractModelBuilder

My main mission is

* have an accessor to the message, in the DNU of RSAbstractModelBuilder
* execute this message with a lot of elements
* difference when apply this command to the main element or its inner component 'target'
* difference when apply the argument to its model or its element 'argumentTarget'

"
Class {
	#name : #RSCommand,
	#superclass : #RSObject,
	#instVars : [
		'message',
		'element',
		'component',
		'isForModel'
	],
	#category : #'Roassal3-Commands'
}

{ #category : #'accessing - computed' }
RSCommand >> argumentTarget [
	^ self isForModel
		ifTrue: [ element model ]
		ifFalse: [ element ]
]

{ #category : #'accessing - computed' }
RSCommand >> arguments [
	| args target |
	args := Array new: message arguments size.
	target := self argumentTarget.
	message arguments doWithIndex: [ :arg :index |
		args at: index put: (arg rsValue: target) ].
	^ args
]

{ #category : #acccessing }
RSCommand >> component [
	^ component
]

{ #category : #acccessing }
RSCommand >> component: anObject [
	component := anObject
]

{ #category : #acccessing }
RSCommand >> element [
	^ element
]

{ #category : #acccessing }
RSCommand >> element: anElement [
	element := anElement
]

{ #category : #executing }
RSCommand >> execute [
	| target arguments |
	target := self target.
	arguments := self arguments.
	target perform: self message selector withArguments: arguments.
	^ arguments.
]

{ #category : #testing }
RSCommand >> isCondition [ 
	^ false
]

{ #category : #acccessing }
RSCommand >> isForModel [
	^  isForModel
]

{ #category : #acccessing }
RSCommand >> isForModel: bool [
	isForModel := bool
]

{ #category : #acccessing }
RSCommand >> message [
	^ message
]

{ #category : #acccessing }
RSCommand >> message: aMessage [
	message := aMessage
]

{ #category : #printing }
RSCommand >> printOn: stream [
	self message printOn: stream
]

{ #category : #dependencies }
RSCommand >> release [ 
	super release.
	element := component := message := nil
]

{ #category : #acccessing }
RSCommand >> selector [
	^ message selector
]

{ #category : #'accessing - computed' }
RSCommand >> target [
	^ (element class canUnderstand: message selector) 
		ifTrue: [ element ]
		ifFalse: [ component ]
]
