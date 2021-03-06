"
TODO
"
Class {
	#name : #RSAbstractRegularTreeLayout,
	#superclass : #RSAbstractGraphLayout,
	#instVars : [
		'alreadyLayoutedNodes',
		'topGap',
		'leftGap',
		'nodesByLayer',
		'isLayered',
		'shouldBeHorizontallyReversed',
		'shouldBeVerticallyReversed'
	],
	#category : #'Roassal3-Layouts-Core'
}

{ #category : #testing }
RSAbstractRegularTreeLayout class >> isAbstract [
	^ self = RSAbstractRegularTreeLayout
]

{ #category : #private }
RSAbstractRegularTreeLayout >> atLayer: aNumber add: aNodeCollection [
	| collection |
	collection := nodesByLayer at: aNumber ifAbsentPut: [OrderedCollection new].
	collection addAll: aNodeCollection
]

{ #category : #hook }
RSAbstractRegularTreeLayout >> doExecute: elements [
	| rootNodes |
	alreadyLayoutedNodes := OrderedCollection new.
	rootNodes := self rootNodesFor: elements.
	nodesByLayer := OrderedCollection new.
	self
		layout: rootNodes
		atPoint: self leftGap @ self topGap
		atLayer: 1.
	self isLayered ifTrue: [
		self rearrangeByLayers: elements ]
]

{ #category : #hook }
RSAbstractRegularTreeLayout >> doPost: elements [
	shouldBeHorizontallyReversed ifTrue: [ self horizontallyReverse: elements ].
	shouldBeVerticallyReversed ifTrue: [ self verticallyReverse: elements ].
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> horizontallyReverse [
	shouldBeHorizontallyReversed := true
]

{ #category : #reversing }
RSAbstractRegularTreeLayout >> horizontallyReverse: elements [
	"Horizontally reverse the elements, as well as the attachpoints"

	| g largeur |
	g := elements asGroup.
	largeur := g extent x.
	elements
		do: [ :el | el translateTo: (largeur - el position x) @ el position y ]
]

{ #category : #'initialize-release' }
RSAbstractRegularTreeLayout >> initialize [
	super initialize.
	topGap := 5.
	leftGap := 5.
	isLayered := false.
	shouldBeHorizontallyReversed := false.
	shouldBeVerticallyReversed := false.
	self doAttachPoint.
]

{ #category : #reversing }
RSAbstractRegularTreeLayout >> inverseAttachPoint [
	"Invert the attach point of all the considered edges. It is likely that all the attachpoint are the same, but we do not have a garanty"
	self shouldSetDefaultAttachPoint ifFalse: [ ^ self ].
	edges
		do: [ :edge | 
			edge shape attachPoint inverted: true.
			edge updateFromTo ]
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> isLayered [
	"Is the layout layered"
	
	^ isLayered
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> isLayered: boolean [
	"Is the layout layered"
	
	isLayered := boolean
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> layered [
	self isLayered: true
]

{ #category : #'hook-private' }
RSAbstractRegularTreeLayout >> layout: aNodeCollection atPoint: aPoint atLayer: anObject [
	self subclassResponsibility
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> leftGap [
	^ leftGap
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> leftGap: anInteger [
	leftGap := anInteger
]

{ #category : #private }
RSAbstractRegularTreeLayout >> rearrangeByLayers: aGraph [
	self subclassResponsibility
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> shouldBeHorizontallyReversed [
	"Return if the layout is horizontally reversed"
	^ shouldBeHorizontallyReversed 
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> shouldBeVerticallyReversed [
	"Return if the layout is vertically reversed"
	^ shouldBeVerticallyReversed
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> topGap [
	^ topGap
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> topGap: anInteger [
	topGap := anInteger
]

{ #category : #accessing }
RSAbstractRegularTreeLayout >> verticallyReverse [
	"Reverse the edge extremities"
	"Here is an example:

| b |	
b := RTMondrian new.
b nodes: (1 to: 100).
b edges connectFrom: [ :v | v // 2 ].
b layout tree verticallyReverse.
b
"
	shouldBeVerticallyReversed := true
	

]

{ #category : #reversing }
RSAbstractRegularTreeLayout >> verticallyReverse: elements [
	"Vertically reverse the elements, as well as the attachpoints"

	| g hauteur |
	g := elements asGroup.
	hauteur := g extent y.
	elements
		do: [ :el | el translateTo: el position x @ (hauteur - el position y) ]
]
