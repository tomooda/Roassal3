"
Test for all shapes with a matrix an one encompassing rectangle
"
Class {
	#name : #TSBoundingTest,
	#superclass : #TSCanvasTest,
	#category : #'Roassal3-Tests-Trachel'
}

{ #category : #running }
TSBoundingTest >> testDrawBitamp [
	c addShape: (TSBitmap new
		form: (ColorForm extent: 100@100 depth: 32)). 
	c morph drawOnMockCanvas.
]

{ #category : #running }
TSBoundingTest >> testDrawBorder [
	c addShape: (TSEllipse new
		radius: 100;
		border: TSBorder new;
		yourself).
	c morph drawOnMockCanvas.
]

{ #category : #running }
TSBoundingTest >> testDrawBoxCornerRadius [
	c addShape: (TSBox new
		extent: 100@100;
		cornerRadius: 5;
		yourself).
	c morph drawOnMockCanvas.
]

{ #category : #running }
TSBoundingTest >> testDrawPolygon [
	c addShape: (TSPolygon new).
	c addShape: (TSPolygon new
		points: { 200@10. 250@190. 160@210 };
		yourself).
	self assert: c shapes second points equals: {(-5@ -100). (45@80). (-45@100)}.
	c morph drawOnMockCanvas.
]

{ #category : #running }
TSBoundingTest >> testDrawRing [
	| r |
	r := TSPieSlice new.
	"empty"
	c addShape: r.
	"circle"
	c addShape: (TSPieSlice new
		innerRadius: 0;
		externalRadius: 100;
		alphaAngle: 0;
		betaAngle: 360).
	"slice"
	c addShape: (TSPieSlice new
		externalRadius: 100;
		alphaAngle: 30;
		betaAngle: 90;
		segmentSpacing: 5).
	"donut"
	c addShape: (TSPieSlice new
		externalRadius: 100;
		innerRadius: 50;
		alphaAngle: 0;
		betaAngle: 360).
	"corner radii"
	c addShape: (TSPieSlice new
		externalRadius: 100;
		innerRadius: 50;
		alphaAngle: 0;
		betaAngle: 45;
		cornerRadii: 20).
	c morph drawOnMockCanvas.
]

{ #category : #tests }
TSBoundingTest >> testPosition [
	| b |
	b := TSBox new.
	self assert: b position equals: 0@0.
	b position: 0@0.
]
