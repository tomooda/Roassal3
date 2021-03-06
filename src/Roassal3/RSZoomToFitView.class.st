"
I add an interaction for the view
"
Class {
	#name : #RSZoomToFitView,
	#superclass : #RSAbstractViewInteraction,
	#category : #'Roassal3-Interaction'
}

{ #category : #hooks }
RSZoomToFitView >> onElement: aView [
	| rect extent sc position scale camera |
	camera := aView camera.
	rect := aView encompassingRectangle.
	extent := aView extent * 0.9.
	sc := extent / (rect extent max: 1 @ 1).
	sc := sc x min: sc y.
	position := TSScale linear
		from: camera position;
		to: rect center.
	scale := TSScale linear
		from: camera scale;
		to: sc.
	camera scale < 1 ifTrue: [ 
		aView animation
			duration: 500 milliSeconds;
			easing: TSEasing backOut;
			onStepDo: [ :t | 
				camera
					position: (position scale: t);
					scale: (scale scale: t).
				aView signalUpdate ].
		^ self ].
	aView animation 
		delay: 150 milliSeconds;
		duration: 700 milliSeconds;
		easing: TSEasing backOut;
		onStepDo: [:t |
			camera position: (position scale: t).
			aView signalUpdate].
	aView animation
		duration: 300 milliSeconds;
		easing: (TSEasing exp);
		onStepDo: [ :t | 
				camera scale: (scale scale: t).
				aView signalUpdate]
	
	
]
