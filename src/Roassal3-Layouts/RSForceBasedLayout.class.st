"
A ROForceBasedLayout is inspired from the Code of D3. The original d3 version may be found on: http://bl.ocks.org/mbostock/4062045

Layout algorithm inspired by Tim Dwyer and Thomas Jakobsen.

"
Class {
	#name : #RSForceBasedLayout,
	#superclass : #RSEdgeDrivenLayout,
	#instVars : [
		'oldPositions',
		'nodes',
		'weights',
		'strengths',
		'lengths',
		'gravity',
		'friction',
		'theta',
		'charge',
		'alpha',
		'charges',
		'strength',
		'length',
		'fixedNodes',
		'center',
		'initialLayout',
		'nbIterations',
		'shouldUseProgressBar'
	],
	#category : #'Roassal3-Layouts-Core'
}

{ #category : #algorithm }
RSForceBasedLayout >> accumulate: aQuad [ 

	| cx cy k random |
	
	cx := 0.
	cy := 0.
	
	aQuad charge: 0; cx: 0; cy: 0.
	
	random := Random new.
	
	aQuad leaf ifFalse: [ aQuad nodes do: [ :e | e isNil ifFalse: [ self accumulate: e.
																aQuad charge: aQuad charge + e charge.
																cx := cx + (e charge * e cx).
																cy := cy + (e charge * e cy) ] ] ].
												
	aQuad node isNil ifFalse: [ aQuad leaf ifFalse: [ aQuad node translateTo: aQuad node position + (random next - 0.5 @ ( random next - 0.5)) ].
								k := alpha * (self chargeOf: aQuad node).
								aQuad charge: aQuad charge + k.
								cx := cx + (k * aQuad node position x). 
								cy := cy + (k * aQuad node position y).].
							
	aQuad charge = 0 ifTrue: [ ^ self ].				
	aQuad cx: cx / aQuad charge.
	aQuad cy: cy / aQuad charge.
]

{ #category : #updating }
RSForceBasedLayout >> addEdge: anEdge [
	self addEdges: (Array with: anEdge)
]

{ #category : #updating }
RSForceBasedLayout >> addEdges: someEdges [
	someEdges
		do: [ :e | 
			| from to |
			from := e from.
			to := e to.
			weights at: from put: (weights at: from) + 1.
			weights at: to put: (weights at: to) + 1 ].
	edges := edges, someEdges
]

{ #category : #updating }
RSForceBasedLayout >> addNodes: nodeElements [
	"Initialize the meta data associated to the nodes. At that stage, position of nodes is not modified"
	nodes := nodes, nodeElements.
	nodeElements
		do: [ :e | 
			weights add: (Association key: e value: 0).
			oldPositions add: (Association key: e value: e position) ].

]

{ #category : #accessing }
RSForceBasedLayout >> charge: aFloat [
	"Typically a negative value. E.g., -300"
	charge := aFloat
]

{ #category : #algorithm }
RSForceBasedLayout >> chargeOf: aNode [ 

	^ charges at: aNode ifAbsent: [ ^ charge ] 
]

{ #category : #'initialize-release' }
RSForceBasedLayout >> defaultInitialLayout [
	^ RSGridLayout new
]

{ #category : #hook }
RSForceBasedLayout >> doExecute: nodeElements [
	self start: nodeElements.
	self shouldRunLayoutWithProgressBar
		ifTrue: [ self runLayoutInJob ]
		ifFalse: [ self runLayoutSimply ].
	alpha := 0.
	nodes do: [ :e | translator translateTopLeftOf: e to: e position ]
]

{ #category : #configuration }
RSForceBasedLayout >> doNotUseProgressBar [
	shouldUseProgressBar := false	
]

{ #category : #algorithm }
RSForceBasedLayout >> fix: aNode at: aPoint [

	fixedNodes at: aNode put: aPoint  
]

{ #category : #algorithm }
RSForceBasedLayout >> gravityAt: aPoint [

	center := aPoint 
]

{ #category : #accessing }
RSForceBasedLayout >> initialLayout: aLayout [
	"Set the initial layout to be used before stepping"
	initialLayout := aLayout
]

{ #category : #hook }
RSForceBasedLayout >> initialPositionOfNodes: nodeElements [
	initialLayout executeOnElements: nodeElements
]

{ #category : #'initialize-release' }
RSForceBasedLayout >> initialize [
	super initialize.
	nbIterations := 0.
	edges := #().
	nodes := #().
	initialLayout := self defaultInitialLayout.
	fixedNodes := Dictionary new.
	strengths := Dictionary new.
	lengths := Dictionary new.
	charges := Dictionary new.
	strength := 1.
	length := 20.
	charge := -30.
	gravity := 0.1.
	friction := 0.9.
	theta := 0.8.
	center := 200 @ 200.
	alpha := 0.1.
	self useProgressBar
]

{ #category : #testing }
RSForceBasedLayout >> isFixed: aNode [

	^ fixedNodes includesKey: aNode 
]

{ #category : #testing }
RSForceBasedLayout >> isJobInstalled [
	"Return true if the class Job exist. This is mainly useful to make a distinction between Pharo and VisualWorks"
	^ Smalltalk includesKey: #Job
]

{ #category : #accessing }
RSForceBasedLayout >> length: aFloat [
	"Specifiy the length of the edges. E.g., 50"
	length := aFloat
]

{ #category : #algorithm }
RSForceBasedLayout >> lengthOf: anEdge [

	^ lengths at: anEdge ifAbsent: [ ^ length ] 
]

{ #category : #accessing }
RSForceBasedLayout >> nbIterations [
	^ nbIterations
]

{ #category : #accessing }
RSForceBasedLayout >> nbIterations: anObject [
	nbIterations := anObject
]

{ #category : #accessing }
RSForceBasedLayout >> nodes [
	^ nodes
]

{ #category : #accessing }
RSForceBasedLayout >> nodes: elements [
	nodes := elements
]

{ #category : #hook }
RSForceBasedLayout >> on: elements edges: edgesCol [
	self nodes: elements.
	self userDefinedEdges: edgesCol.
	self applyOn: elements.
]

{ #category : #accessing }
RSForceBasedLayout >> prepareNodes: nodeElements [
	"Initialize the meta data associated to the nodes. At that stage, position of nodes is not modified"
	weights := Dictionary new.
	oldPositions := Dictionary new.
	nodes := nodeElements.
	nodes
		do: [ :e | 
			weights add: (Association key: e value: 0).
			oldPositions add: (Association key: e value: e position) ].
	edges
		do: [ :e | 
			| from to |
			from := e from.
			to := e to.
			weights at: from put: (weights at: from) + 1.
			weights at: to put: (weights at: to) + 1 ].
	alpha := 0.1
]

{ #category : #updating }
RSForceBasedLayout >> removeAllEdges [
	edges := OrderedCollection new
]

{ #category : #updating }
RSForceBasedLayout >> removeEdge: ed [
	edges remove: ed
]

{ #category : #updating }
RSForceBasedLayout >> removeNode: node [
	nodes remove: node.
	node connectedEdges do: [ :ed | self removeEdge: ed. ]
]

{ #category : #algorithm }
RSForceBasedLayout >> repulse: aNode from: aQuad [

	| dx dy dn k p |
	
	dx := aQuad cx - aNode position x.
	dy := aQuad cy - aNode position y.
	
	((dx closeTo: 0) and: [ dy closeTo: 0 ] ) ifFalse: [ 
	
	dn := 1 / ((dx * dx) + (dy * dy)) sqrt.
	
	p := oldPositions at: aNode.
	aQuad node ~= aNode ifTrue: [ aQuad corner x - aQuad origin x * dn < theta ifTrue: [ k := aQuad charge * dn * dn.
																							oldPositions at: aNode put: p x - (dx * k) @ (p y - (dy * k) ).
																							^ self].
												
									(aQuad node isNil not and: [ dn < 1e9 ]) ifTrue: [ k := (self chargeOf: aQuad node) * dn * dn * alpha.
																					  oldPositions at: aNode put: p x - (dx * k) @ (p y - (dy * k) ) ] ]. ].
																			
	(aQuad charge closeTo: 0) not ifTrue: [ aQuad nodes do: [ :e | e isNil ifFalse: [ self repulse: aNode from: e ] ] ]
]

{ #category : #hook }
RSForceBasedLayout >> runLayoutInJob [
	[ :job | 
	job
		title: 'Laying out elements';
		min: 1 - alpha;
		max: 1.
	nbIterations = 0
		ifTrue: [ 
			[ 
			alpha := alpha * 0.99.
			alpha > 0.005 ]
				whileTrue: [ 
					self step.
					job currentValue: 1 - alpha ] ]
		ifFalse: [ 
			nbIterations
				timesRepeat: [ 
					alpha := alpha * 0.99.
					self step.
					job currentValue: 1 - alpha ] ] ] asJob run
]

{ #category : #hook }
RSForceBasedLayout >> runLayoutSimply [
	nbIterations = 0
		ifTrue: [ 
			[ 
			alpha := alpha * 0.99.
			alpha > 0.005 ] whileTrue: [ self step ] ]
		ifFalse: [ 
			nbIterations
				timesRepeat: [ 
					alpha := alpha * 0.99.
					self step ] ]
]

{ #category : #algorithm }
RSForceBasedLayout >> set: aNode charge: aFloat [ 

	charges at: aNode put: aFloat
]

{ #category : #algorithm }
RSForceBasedLayout >> set: anEdge length: aFloat [ 

	lengths at: anEdge put: aFloat
]

{ #category : #algorithm }
RSForceBasedLayout >> set: anEdge length: aFloat strength: another [

	lengths at: anEdge put: aFloat.
	strengths at: anEdge put: another 
]

{ #category : #algorithm }
RSForceBasedLayout >> set: anEdge strength: aFloat [ 

	strengths at: anEdge put: aFloat
]

{ #category : #updating }
RSForceBasedLayout >> shouldRunLayoutWithProgressBar [
	^ self isJobInstalled and: [ self shouldUseProgressBar ]
]

{ #category : #accessing }
RSForceBasedLayout >> shouldUseProgressBar [
	^ shouldUseProgressBar
]

{ #category : #accessing }
RSForceBasedLayout >> start: nodeElements [
	self initialPositionOfNodes: nodeElements.
	self prepareNodes: nodeElements
]

{ #category : #events }
RSForceBasedLayout >> step [ 
	"run a step of the force layout algorithm"
	| from to fp tp x y len k quad old |	
		
	"If there is no nodes, then there is not much to do"
	nodes ifEmpty: [ ^ self ].
	super step.
	edges do: [ :e | 
					from := e from. 
					fp := from position.
					to := e to. 
					tp := to position.
					x := tp x - fp x.
					y := tp y - fp y.
					len := ((x * x) + (y * y)) sqrt.
					((len closeTo: 0) not) ifTrue: [ 
						len :=  alpha * (self strengthOf: e) * ( len - (self lengthOf: e) ) / len.
						x := x * len.
						y := y * len.
						k := (weights at: from) / (( weights at: from) +( weights at: to )).
						to translateTo: ( tp x - (x * k) )@( tp y - (y * k) ).
						k := 1 -  k.
						from translateTo: ( fp x + (x * k) )@( fp y + (y * k) ) ] ].
			
		k := alpha * gravity.
		((k closeTo: 0) not) ifTrue: [ 
			x := center x.
			y := center y.
			nodes do: [ :ea | | pos |
					pos := ea position.
					ea translateTo: (pos x + ((x - pos x)* k)) @ (pos y + (( y - pos y )* k )) ] ].
				
		quad := RSQuadTree withAll: nodes.
		self accumulate: quad.
		nodes do: [ :e | 
			(self isFixed: e) 
				ifFalse: [ self repulse: e from: quad ]
				ifTrue: [ translator translateTopLeftOf: e to: (fixedNodes at: e) ] ].

		nodes do: [ :e | 
			old := e position.
			e translateTo: 
				(old x - (( (oldPositions at: e) x - old x ) * friction)) @ 
				(old y - (( (oldPositions at: e) y - old y ) * friction)).
			oldPositions at: e put: old.].
]

{ #category : #accessing }
RSForceBasedLayout >> strength: aFloat [
	"Set the force of attraction for the edges. A high value results in having nodes together.
	The default value is 1.0"
	strength := aFloat
]

{ #category : #algorithm }
RSForceBasedLayout >> strengthOf: anEdge [

	^ strengths at: anEdge ifAbsent: [ ^ strength ] 
]

{ #category : #configuration }
RSForceBasedLayout >> useProgressBar [
	shouldUseProgressBar := true	
]

{ #category : #public }
RSForceBasedLayout >> userDefinedEdges: aCollectionOfEdges [
	"useful to tell to the layout which edges have to be used for the layout"
	userDefinedEdges := aCollectionOfEdges select: [ :e |
		(nodes includes: e from) and: [ nodes includes: e to ] ]
	
]
