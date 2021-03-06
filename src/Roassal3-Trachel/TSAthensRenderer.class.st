"
I can create a visual components in a athensCanvas surface.
"
Class {
	#name : #TSAthensRenderer,
	#superclass : #TSRenderer,
	#instVars : [
		'builder'
	],
	#category : #'Roassal3-Trachel-Core'
}

{ #category : #utilities }
TSAthensRenderer >> arcCornerTangets: p0 p1: p1 r: r1 rc: rc cw: cw [
	| x01 y01 lo ox oy x1 y1 x2 y2 x3 y3 dx dy d2 r d D cx0 cy0 cx1 cy1 dx0 dy0 dx1 dy1 |
	x01 := p0 x - p1 x.
	y01 := p0 y - p1 y.
	lo := (cw ifTrue:[rc ] ifFalse: [ rc negated ]) / ((x01 * x01) + (y01*y01)) sqrt.
	ox := lo * y01.
	oy := lo negated * x01.
	x1 := p0 x + ox.
	y1 := p0 y + oy.
	x2 := p1 x + ox.
	y2 := p1 y + oy.
	x3 := (x1 + x2)/2.
	y3 := (y1 + y2)/2.
	dx := x2 - x1.
	dy := y2 - y1.
	d2 := (dx * dx) + (dy * dy).
	r := r1 - rc.
	D := (x1 * y2) - (x2 * y1).
	d := (dy < 0 ifTrue: [ -1 ] ifFalse: [ 1 ]) * (0 max: ((r*r *d2) - (D * D) ) ) sqrt.
	cx0 := ((D * dy) - (dx * d)) / d2.
	cy0 := ( (D negated * dx) - (dy * d) ) / d2.
	cx1 := ((D * dy) + (dx * d)) / d2.
	cy1 := ( (D negated * dx) + (dy * d) ) / d2.
	dx0 := cx0 - x3.
	dy0 := cy0 - y3.
	dx1 := cx1 - x3.
	dy1 := cy1 - y3.
	((dx0 * dx0) + (dy0 * dy0)) > ((dx1 * dx1) + (dy1 * dy1)) ifTrue: [ 
		cx0 := cx1.
		cy0 := cy1 ].
	^  (cx0 - ox)@ (cy0 - oy) negated -> ((cx0 * r1 / r)@(cy0 * r1/r) negated).



]

{ #category : #utilities }
TSAthensRenderer >> arcSweep: p1 and: p2 [
	^ ((p1 x - p2 x)* p1 y) - ((p1 y - p2 y) * p1 x) > 0
		ifTrue: [ 1 ] 
		ifFalse: [ 0 ]
]

{ #category : #utilities }
TSAthensRenderer >> asin: x [
	^ x >= 1
	ifTrue: [ 1.5707963267948966 ]
	ifFalse: [ x <= -1
		ifTrue: [ -1.5707963267948966 ]
		ifFalse: [ x arcSin ] ].
	
]

{ #category : #'creating path' }
TSAthensRenderer >> buildBezierPath: bezier [
	| points |
	points := bezier controlPoints.
	points size = 2 ifTrue: [ 
		builder 
			absolute; 
			moveTo: points first; 
			lineTo: points second.
		^ self ].
	points size = 3 ifTrue: [ 
		builder 
			absolute; 
			moveTo: points first; 
			curveVia: points second 
				to: points third.
		^ self ].
	points size = 4 ifTrue: [ 
		builder
			absolute; 
			moveTo: points first; 
			curveVia: points second 
				and: points third 
				to: points fourth  ].

	
]

{ #category : #'creating path' }
TSAthensRenderer >> buildBoxPath: box [
	| rectangle simple corner |
	rectangle := box baseRectangle.
	simple := [ 
		builder
			absolute;
			moveTo: rectangle topLeft;
			lineTo: rectangle topRight;
			lineTo: rectangle bottomRight;
			lineTo: rectangle bottomLeft;
			lineTo: rectangle topLeft;
			closePath ].
	corner := [ 
		| c |
		c := box cornerRadius.
		builder
			absolute;
			moveTo: rectangle topLeft + (c topLeft@0);
			lineTo: rectangle topRight - (c topRight@0);
			cwArcTo: rectangle topRight + (0@c topRight) angle: Float halfPi;
			lineTo: rectangle bottomRight- (0 @ c bottomRight);
			cwArcTo: rectangle bottomRight - (c bottomRight @ 0) angle: Float halfPi;
			lineTo: rectangle bottomLeft + (c bottomLeft @ 0);
			cwArcTo: rectangle bottomLeft - (0@ c bottomLeft) angle: Float halfPi;
			lineTo: rectangle topLeft + (0@ c topLeft);
			cwArcTo: rectangle topLeft + (c topLeft@0) angle: Float halfPi;
			closePath
		 ].

	box hasCornerRadius 
		ifTrue: corner
		ifFalse: simple
	
]

{ #category : #'creating path' }
TSAthensRenderer >> buildEllipsePath: ellipse [
	| extent halfWidth halfHeight |
	extent := ellipse extent.
	halfWidth := extent x / 2 asFloat.
	halfHeight := extent y / 2 asFloat.
	
	builder
		absolute;
		moveTo: 0@0;
		relative;
		moveTo: halfWidth negated @ 0;
		curveVia: 0 @ (halfHeight negated * 0.55)
			and: (0.45 * halfWidth) @ halfHeight negated
			to: halfWidth @ halfHeight negated;
		curveVia: (halfWidth * 0.55) @ 0
			and: halfWidth @ (0.45 * halfHeight)
			to: halfWidth @ halfHeight;
		curveVia: 0 @ (halfHeight * 0.55)
			and: (0.45 * halfWidth negated) @ halfHeight
			to: halfWidth negated @ halfHeight;
		curveVia: (halfWidth negated * 0.55) @ 0
			and: halfWidth negated @ (halfHeight negated * 0.45)
			to: halfWidth negated @ halfHeight negated.
	


]

{ #category : #'creating path' }
TSAthensRenderer >> buildLinePath: line [
	builder
		absolute;
		moveTo: line startPoint;
		lineTo: line endPoint.
]

{ #category : #'creating path' }
TSAthensRenderer >> buildPolygonPath: path [
	| first |
	first := true.
	builder absolute.
	path points do: [ :point |
		first ifTrue: [ 
			first := false.
			builder moveTo: point ]
		ifFalse: [ 
			builder lineTo: point ] ].
	builder closePath.
]

{ #category : #'creating path' }
TSAthensRenderer >> buildPolyinePath: path [
	| first |
	first := true.
	builder absolute.
	path controlPoints do: [ :point |
		first ifTrue: [ 
			first := false.
			builder moveTo: point ]
		ifFalse: [ 
			builder lineTo: point ] ].
]

{ #category : #'creating path' }
TSAthensRenderer >> buildRingPath: ring [
	| aAngle bAngle xAngle i e center ap epsilon aAngle2 bAngle2 rp da da0 da1 rc x1 x2 x3 x4 y1 y2 y3 y4 rc0 rc1 t41 t23  t14 t32 |
	epsilon := 1e-12.
	ap := (ring segmentSpacing / 2) degreesToRadians.
	aAngle := ring alphaAngle degreesToRadians.
	bAngle := ring betaAngle degreesToRadians.
	da := da0 := da1 := (aAngle - bAngle) abs.
	aAngle2 := aAngle.
	bAngle2 := bAngle.
	center := 0@0.
	i := ring innerRadius asFloat.
	e := ring externalRadius.
	"builder setFillRuleEvenOdd."
	
	builder absolute.
	"is it a point? "
	e < epsilon ifTrue: [ ^ builder  moveTo: center ].
	
	"or is a circle? "
	da0 > (Float pi * 2 - epsilon) ifTrue: [ 
		builder 
			moveTo: ((e * aAngle cos)@( e * aAngle sin negated)) + center ;
			arcAround: center radius: e startAngle: aAngle endAngle: bAngle.
		i > epsilon ifTrue: [ 
			builder
				moveTo: (i * (aAngle cos @ aAngle sin negated) )+ center ;
				arcAround: center radius: i startAngle: aAngle endAngle: bAngle ].
		builder close.
		^ self ]. 
	"circle part"
	xAngle := (aAngle + bAngle)/2.
	rp := ((i*i) + (e*e)) sqrt.
	"apply padding"
	rp > epsilon ifTrue: [ | p0 p1 |
		p0 := i isZero 
			ifTrue: [ self asin: Float infinity ]
			ifFalse: [ self asin: (rp / i * ap sin) ].
		p1 := self asin: (rp / e * ap sin).
		da0 := da0 - (p0*2).
		da0 > epsilon
			ifTrue: [ aAngle2 := aAngle2 + p0. bAngle2 := bAngle - p0 ] 	
			ifFalse: [ aAngle2 := bAngle2 := (aAngle + bAngle)/2. ].
		da1 := da1 - (p1*2).
		da1 > epsilon
			ifTrue: [ aAngle := aAngle + p1. bAngle := bAngle - p1 ]
			ifFalse: [ aAngle := bAngle := xAngle] ].
	x1 := e*aAngle cos.
	y1 := e*aAngle sin.
	x2 := e*bAngle cos.
	y2 := e*bAngle sin.
	x4 := i*aAngle2 cos.
	y4 := i*aAngle2 sin.
	x3 := i*bAngle2 cos.
	y3 := i*bAngle2 sin.
	
	"is it small circle part?"
	(aAngle - bAngle) abs < 0.001 ifTrue: [ 
		builder 
			moveTo: (x3@y3) + center;"
			lineTo: (x2@y2) + center;"
			close.
		^ self ].
	"apply corner radius"
	rc := ((i -e) abs /2) min: ring cornerRadii.
	rc0 := rc1 := rc.
	(da > epsilon and: [ rc > 0.001 ]) ifTrue: [ 	
		da < Float pi ifTrue: [ 
			| oc ax ay bx by kc lc |
			oc := self geomPolygonIntersectC: x1@y1 d: x4@y4 a: x2@y2  b: x3@y3.
			ax := x1 - oc x.
			ay := y1 - oc y.
			bx := x2 - oc x.
			by := y2 - oc y.
			kc := 1 / (( ((ax*bx) + (ay*by)) /  ( ((ax*ax)+ (ay*ay)) sqrt * ( (bx*bx)+(by*by) ) sqrt ) ) arcCos / 2) sin.
			lc := ((oc x * oc x) + (oc y*oc y)) sqrt.
			rc0 := rc0 min: ((e - lc) / (kc + 1)).
			rc1 := rc1 min: ((i - lc) / (kc - 1)).
			].
		].

	t41 := self arcCornerTangets: x4@y4 p1: x1@y1 r: e rc: rc0 cw: true.
	t23 := self arcCornerTangets: x2@y2 p1: x3@y3 r: e rc: rc0 cw: true.
	builder moveTo: t41 key + center.
	rc0 == rc ifTrue: [ 
		builder 
			ellipticalArc2: rc0@rc0 
				xrot: 0
				large: 0
				sweep: 0
				to: t41 value + center;
			ellipticalArc2: e@e
				xrot: 0
				large: (self arcSweep: t41 value and: t23 value)
				sweep: 0
				to: t23 value + center;
			ellipticalArc2: rc0@rc0
				xrot: 0
				large: 0
				sweep: 0
				to: t23 key + center.
			 ]
	ifFalse: [ 
		builder 
			ellipticalArc2: rc0@rc0 
				xrot: 0 
				large: 1 
				sweep: 0
				to: t23 key + center ].
	
	(x4 isZero & y4 isZero) ifTrue: [ 
		builder lineTo: center. ]
	ifFalse: [ 
		t14 := self arcCornerTangets: x1@y1 p1: x4@y4 r: i rc: rc1 negated cw: true.
		t32 := self arcCornerTangets: x3@y3 p1: x2@y2 r: i rc: rc1 negated cw: true.
		builder lineTo: t32 key + center.
		(rc == rc1 and: [da0 > 0 ]) ifTrue: [ 
			builder 
				ellipticalArc2: rc1@ rc1
					xrot: 0
					large: 0
					sweep: 0
					to: t32 value + center;
				ellipticalArc2: i@i
					xrot: 0
					large: (self arcSweep: t14 value and: t32 value) 
					sweep: 1
					to: t14 value + center;
				ellipticalArc2: rc1@rc1
					xrot: 0
					large: 0
					sweep: 0
					to: t14 key + center
		] ifFalse: [ 
			builder 
				ellipticalArc2: rc1@ rc1
					xrot: 0
					large: 0
					sweep: 0
					to: t14 key + center
	 	] ] .
	builder close.
]

{ #category : #'creating path' }
TSAthensRenderer >> buildSVGPathLine: line [
	| string |
	string := line svgPath value: line startPoint value: line endPoint.
	
	string isString ifTrue: [ | converter |
		converter := ASPathConverter new stream: string readStream.
		converter convertPathData do: [ :each | 
			builder 
				perform: each first 
				withArguments: each second ]
	] ifFalse: [
		string value: builder.
	].
	
]

{ #category : #accessing }
TSAthensRenderer >> builder [
	^ builder
]

{ #category : #utilities }
TSAthensRenderer >> geomPolygonIntersectC: c d: d a: a b: b [

	| x1 x3 x21 x43 y1 y3 y21 y43 ua |
	x1 := c x.
	x3 := a x.
	x21 := d x - x1.
	x43 := b x - x3.
	y1 := c y.
	y3 := a y.
	y21 := d y - y1.
	y43 := b y - y3.
	ua := ((x43 *  (y1 - y3)) - (y43 * (x1 - x3))) / ((y43 * x21) - (x43 * y21 )).
	^ (x1 + (ua * x21))@
	(y1 +(ua * y21))
]

{ #category : #'creating path' }
TSAthensRenderer >> getOrCreatePathOf: shape [
	| path |
	path := shape path.
	path ifNotNil: [ ^ path ].
	path ifNil: [ 
		path := athensCanvas
			createPath: [ :pathBuilder |
				builder := pathBuilder.
				shape buildPathOn: self ].
		builder := nil.
		shape path: path ].
	^ path
]

{ #category : #paint }
TSAthensRenderer >> paintForBitmap: shape [
	| paint |
	^ CairoBackendCache soleInstance 
		at: shape form
		ifAbsentPut: [ 
			paint := (AthensCairoPatternSurfacePaint 
				createForSurface: (AthensCairoSurface 
				fromForm: shape form)).
			paint origin: (shape form extent /2) negated asFloatPoint.
			paint  ]
]

{ #category : #visiting }
TSAthensRenderer >> visitBorder: border [
	| stroke style |
	stroke := athensCanvas setStrokePaint: border paint.
	stroke width: border width asFloat.
	style := border style.
	style ifNil: [ ^ stroke ].
	style dashArray 
		ifNotNil: [ :a | stroke dashes: a offset: style dashOffset ].
	style capStyle
		ifNotNil: [:s | stroke perform: s].
	style joinStyle
		ifNotNil: [:s | stroke perform: s].
	^ stroke.
	
]

{ #category : #'visiting - helpers' }
TSAthensRenderer >> visitBorderIfNecessary: shape [
	shape hasBorder ifFalse: [ ^ self ].
	athensCanvas setShape: shape path.
	shape border accept: self.
	athensCanvas draw.
]

{ #category : #visiting }
TSAthensRenderer >> visitBoundingShape: shape [
	| path paint |
	path := self getOrCreatePathOf: shape.
	athensCanvas pathTransform restoreAfter: [ 
		athensCanvas pathTransform
			multiplyBy: shape matrix asFloatTransform.
		paint := shape paintOn: self.
		paint ifNotNil: [ 
			athensCanvas 
				setPaint: paint;
				drawShape: path ].
		self visitBorderIfNecessary: shape.
		shape shapes ifNotNil: [ 
			shape shapes do: [ :s |
				s accept: self ] ]
		].
	
]

{ #category : #visiting }
TSAthensRenderer >> visitLabel: label [
	athensCanvas pathTransform restoreAfter: [ 
		| utf8String act f stroke |
		athensCanvas pathTransform
			multiplyBy: label matrix asFloatTransform;
			translateBy: ((label textWidth / -2) @ (label textHeight / 2)) asFloatPoint;
			translateBy: (0 @ label descent negated) asFloatPoint.
		
			utf8String := label path.
			utf8String ifNil: [ 
				act := AthensCairoText new.
				utf8String := act convertTextUtf8: label text.
				label path: utf8String.
			 ].
			f := CairoScaledFont fromFreetypeFont: label font realFont.
			
			athensCanvas newPath.
			f lock.
			athensCanvas 
				setPathMatrix;
				setScaledFont: f.
			label paint ifNotNil: [ 
				(label paint asAthensPaintOn: athensCanvas)
					loadOnCairoCanvas: athensCanvas. ].
			athensCanvas textPath: utf8String.
			label paint ifNotNil: [ athensCanvas fillPreserve ].
			label hasBorder ifTrue: [ 
				label border paint loadOnCairoCanvas: athensCanvas.
				stroke := label border accept: self.
				stroke prepareForDrawingOn: athensCanvas.
				athensCanvas stroke.
			 ].
			f unlock.
		].
	

]

{ #category : #visiting }
TSAthensRenderer >> visitLine: line [
	| path paint |
	athensCanvas pathTransform restoreAfter: [ 
		path := self getOrCreatePathOf: line.
		paint := line paint.
		paint ifNotNil: [ 
			athensCanvas
				setPaint: paint;
				drawShape: path ].
		self visitBorderIfNecessary: line.
		].
]
