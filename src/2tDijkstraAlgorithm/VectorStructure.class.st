"
I represent a Vector data structure. All the functionality I offer is through FFI calls to C functions. 
 So, to make use of me, make sure you have the libVectorDoste dynamic library compiled and ready to use.

 Once it's done, you would have to set my class variable for me to find it (the variable is pathToLibrary).


 [The main reason I implemented this was to learn about uFFI. So, I wanted to implement a data structure in C which would be called from Pharo code.
	So, all of this is just for learning purposes, don't expect it to be for speed, performance, etc. ]
"
Class {
	#name : #VectorStructure,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_ARRAY',
		'OFFSET_CAPACITY',
		'OFFSET_SIZE',
		'pathToLibrary'
	],
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #'field definition' }
VectorStructure class >> fieldsDesc [ 
	^ #(
			int size;	
    		int capacity;
			int* array;
		)
]

{ #category : #'class initialization' }
VectorStructure class >> initialize [ 
]

{ #category : #'as yet unclassified' }
VectorStructure class >> pathToLibrary [
	^ pathToLibrary
]

{ #category : #'as yet unclassified' }
VectorStructure class >> pathToLibrary: aPath [
	pathToLibrary := aPath 
]

{ #category : #'accessing - structure variables' }
VectorStructure >> array [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_ARRAY) type: ExternalType long asPointerType
]

{ #category : #'accessing - structure variables' }
VectorStructure >> array: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_ARRAY put: anObject getHandle.
]

{ #category : #converting }
VectorStructure >> asPharoArray [
	"| resultArray |
	
	resultArray := Array new: self size.
	1 to: (self size) do: [ :i | resultArray at: i put: (self elementAt: i-1) ].
	^ resultArray 
	
	better with collect: :D"
	
	^ (1 to: (self size)) collect: [ :i | self elementAt: i-1 ].
]

{ #category : #'accessing - structure variables' }
VectorStructure >> capacity [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_CAPACITY
]

{ #category : #'accessing - structure variables' }
VectorStructure >> capacity: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_CAPACITY put: anObject
]

{ #category : #actions }
VectorStructure >> debugVector [	
	| i stringDescription |
	
	stringDescription := String new.
	
	i := 1.
	
	(1 to: self size) do: [ :elem | stringDescription := stringDescription, (self elementAt: i) asString , String cr.  i := i + 1].
	
	^ stringDescription
]

{ #category : #enumerating }
VectorStructure >> do: aBlock [
		"example of usage: 
		  do:[ :elem | stringElements := stringElements, elem toString, String cr ]."
		
		0 to: self size do: [ :i |
				aBlock value: (self elementAt: i).
		].
		
]

{ #category : #actions }
VectorStructure >> elementAt: index [
	
	^ self ffiCall: #(int iesimo(VectorStructure* self, int index)) library: (self class pathToLibrary).
]

{ #category : #initialization }
VectorStructure >> initialize [ 
]

{ #category : #'instance creation' }
VectorStructure >> newVectorFromExternalCall [
	^ self ffiCall: #(VectorStructure* nuevo_vector(void)) library: (self class pathToLibrary).
]

{ #category : #'instance creation' }
VectorStructure >> newVectorWithNumberOfElements: numberOfElements withValue: value [
	"^ self ffiCall: #(VectorStructure* init_with_value(int numberOfElements, int value)) library: '/Users/juanidoste/Downloads/dosteLib/libVectorDoste.dylib'."
	
	^ self ffiCall: #(VectorStructure* init_with_value(int numberOfElements, int value)) library: (self class pathToLibrary).
]

{ #category : #actions }
VectorStructure >> pushBack: anElement [

	self ffiCall: #(void push_back(VectorStructure* self, int anElement)) library: (self class pathToLibrary).
]

{ #category : #actions }
VectorStructure >> setElement: anElement atIndex: index [
	
	self ffiCall: #(void set_iseimo(VectorStructure* self, int index, int anElement)) library: (self class pathToLibrary).
]

{ #category : #'accessing - structure variables' }
VectorStructure >> size [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_SIZE
]

{ #category : #'accessing - structure variables' }
VectorStructure >> size: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_SIZE put: anObject
]
