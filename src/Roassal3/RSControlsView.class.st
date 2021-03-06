"
I am experimental class.
Add to the view the next interactions
- RSZoomableView
- RSDraggableView
 
- RSMenuActivable
- RSZoomMove
- RSFocusOnCenterScaleMove

"
Class {
	#name : #RSControlsView,
	#superclass : #RSAbstractViewInteraction,
	#instVars : [
		'translationAnimation',
		'keyUpActions',
		'keyDownActions',
		'steps',
		'speed'
	],
	#category : #'Roassal3-Interaction'
}

{ #category : #initialization }
RSControlsView >> initialize [
	super initialize.
	steps := Set new.
	speed := 1.
	keyDownActions := Dictionary new
		at: 28 put: -1 @ 0; "left"
		at: 29 put: 1 @ 0; "right"
		at: 30 put: 0 @ -1; "up"
		at: 31 put: 0 @ 1; "down"
		yourself.
	keyUpActions := Dictionary new "mac" "TODO review asKeyCombination and this in other os"
		at: 34 put: RSZoomMove in;
		at: 31 put: RSZoomMove out;
		at: 3 put: RSZoomToFitView new;
		at: 123 put: -1@ 0; "left"
		at: 124 put: 1 @ 0; "right"
		at: 126 put: 0 @ -1; "up"
		at: 125 put: 0 @ 1; "down"
		yourself.
]

{ #category : #hooks }
RSControlsView >> onElement: aView [
	aView @ RSZoomableView.
	aView @ RSDraggableView.
	
	aView
		when: TSKeyDown do: [ :evt| self processKeyDown: evt ];
		when: TSKeyUp do: [ :evt | self processKeyUp: evt ].
	
	RSMenuActivable new 
		onElement: aView;
		menuDo: [:menu | 
			(menu 
				add: 'Zoom in'
				target: RSZoomMove in
				selector: #onElement: 
				argument: aView)
				icon: (self iconNamed: #glamorousZoomIn).
			(menu 
				add: 'Zoom to fit'
				target: RSZoomToFitView new
				selector: #onElement: 
				argument: aView)
				icon: (self iconNamed: #glamorousZoomToFit).
			(menu 
				add: 'Zoom out'
				target: RSZoomMove out
				selector: #onElement: 
				argument: aView)
				icon: (self iconNamed: #glamorousZoomOut) ].

	
]

{ #category : #hooks }
RSControlsView >> processKeyDown: evt [
	| action |
	action := keyDownActions at: evt keyValue ifAbsent: [^ self ].
	steps add: action.
	speed := evt shiftKeyPressed ifTrue: [  10 ] ifFalse: [ 3 ].
	translationAnimation ifNil: [  
		translationAnimation := evt canvas animation repeat
			onStepDo: [ :t | | step |
				step := steps inject: 0@0 into: [:p :s |p+s ].
				
				evt canvas camera translateBy: step / (evt canvas camera scale / speed).
				evt signalUpdate ] ].
]

{ #category : #hooks }
RSControlsView >> processKeyUp: evt [
	| action remove |
	action := keyUpActions at: evt keyValue ifAbsent: [^ self ].
	remove := [ 
		(steps isEmpty and: [ translationAnimation notNil ]) ifTrue:  [ 
			translationAnimation stop.
			translationAnimation := nil ] ].
	action isPoint ifFalse: [
		steps removeAll.
		remove value.
		^ action onElement: evt canvas  ].
	steps remove: action ifAbsent: [ ].
	remove value.
	
]
