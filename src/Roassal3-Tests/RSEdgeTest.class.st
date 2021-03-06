"
I have tests for RSEdge
"
Class {
	#name : #RSEdgeTest,
	#superclass : #TSTest,
	#instVars : [
		'el1',
		'el2',
		'edge'
	],
	#category : #'Roassal3-Tests-Roassal'
}

{ #category : #running }
RSEdgeTest >> setUp [
	super setUp.
	el1 := RSShapeBuilder box element.
	el2 := RSShapeBuilder box element.
	el1 translateTo: 20 @ 20.
	el2 translateTo: 60 @ 80.
	edge := RSEdgeBuilder line from: el1; to: el2; edge.

]

{ #category : #tests }
RSEdgeTest >> testAddingEdgeAndGroup [

	| v g |
	v := RSView new.
	g := TSGroup new.
	
	g
		add: el1;
		add: el2;
		add: edge.
	v addAll: g.
	self assert: edge trachelShape notNil.
	self assert: edge trachelShape color notNil.
]
