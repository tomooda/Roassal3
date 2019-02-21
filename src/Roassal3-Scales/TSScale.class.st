"
I am a common scale interpolator, just put your entry value and this objects scale and return the value in your domain
"
Class {
	#name : #TSScale,
	#superclass : #TSObject,
	#instVars : [
		'domain',
		'range',
		'interpolate',
		'uninterpolate'
	],
	#category : #'Roassal3-Scales'
}

{ #category : #'instance creation' }
TSScale class >> category10 [
	^ self fromColorCategory: #category10
]

{ #category : #'instance creation' }
TSScale class >> category20 [
	^ self fromColorCategory: #category20
]

{ #category : #'instance creation' }
TSScale class >> category20b [
	^ self fromColorCategory: #category20b
]

{ #category : #'instance creation' }
TSScale class >> category20c [
	^ self fromColorCategory: #category20c
]

{ #category : #'instance creation' }
TSScale class >> fromColorCategory: symbol [
	^ self ordinal 
		range: (TSColorInterpolator perform: symbol);
		yourself
]

{ #category : #'instance creation' }
TSScale class >> google20 [
	^ self fromColorCategory: #google20
]

{ #category : #'instance creation' }
TSScale class >> linear [
	^ TSScaleLinear new. 
]

{ #category : #'instance creation' }
TSScale class >> log [
	^ TSScaleLog new
]

{ #category : #'instance creation' }
TSScale class >> ordinal [
	^ TSScaleOrdinal new 
]

{ #category : #'instance creation' }
TSScale class >> paired12 [
	^ self fromColorCategory: #sky8
]

{ #category : #'instance creation' }
TSScale class >> sqrt [
	^ self pow
		exponent: 0.5; 
		yourself
]

{ #category : #accessing }
TSScale >> domain [
	^ domain
]

{ #category : #accessing }
TSScale >> domain: anObject [
	domain := anObject
]

{ #category : #accessing }
TSScale >> interpolate [
	^ interpolate
]

{ #category : #accessing }
TSScale >> interpolate: anObject [
	interpolate := anObject.
]

{ #category : #transformation }
TSScale >> invert: anObject [
	"This is the inverse of scale"
	self subclassResponsibility.
]

{ #category : #accessing }
TSScale >> range [
	^ range
]

{ #category : #accessing }
TSScale >> range: anObject [
	range := anObject
]

{ #category : #hooks }
TSScale >> rescale [
	self subclassResponsibilitya
]

{ #category : #transformation }
TSScale >> rsValue: obj [
	^ self scale: obj
]

{ #category : #transformation }
TSScale >> scale: anObject [
	"do you have your domain, and your range? ok so use this method in one of my subclasses"
	self subclassResponsibility
]

{ #category : #accessing }
TSScale >> uninterpolate [
	^ uninterpolate
]

{ #category : #accessing }
TSScale >> uninterpolate: anObject [
	uninterpolate := anObject
]