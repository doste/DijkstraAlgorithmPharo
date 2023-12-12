"
I represent a class to run the Dijkstra's Shortest Path Algorithm for weighted graphs.

 To make use of me you have to:
	. First build the graph. To do this I offer you a class to help you with that: AdjacencyListBuilder.
		
	. Then, run the main method
		 dijkstraFrom: source
	 which will take as the only argument the vertex that you want to run the algorithm from.
	
	. As output, I will give you two vectors: the distances and the parent. These would describe the distances of each vertex to the given source and the paths.
	
You have to make sure to correctly set the paths to the dynamic libraries I need:
	* libVectorDoste
	* libDijkstraC

The second one is only if you would like to test my implementantion against a C implementation of the same algorithm.

To set said paths you would have to modify my initialize method.
"
Class {
	#name : #DijkstraAlgorithm,
	#superclass : #Object,
	#instVars : [
		'adjacencyList',
		'distancesVector',
		'parentVector'
	],
	#classVars : [
		'pathToLibrary'
	],
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #'as yet unclassified' }
DijkstraAlgorithm class >> pathToLibrary [
	^ pathToLibrary 
]

{ #category : #'as yet unclassified' }
DijkstraAlgorithm class >> pathToLibrary: aPath [
	pathToLibrary := aPath 
]

{ #category : #accessing }
DijkstraAlgorithm >> adjacencyList [

	^ adjacencyList
]

{ #category : #accessing }
DijkstraAlgorithm >> adjacencyList: anObject [

	adjacencyList := anObject
]

{ #category : #accessing }
DijkstraAlgorithm >> adjacencyListOfVertex: aVertex [
	"Returns an DosteLinkedList representing the neighborhood of aVertex."
	 ^ self adjacencyList at: aVertex
]

{ #category : #'as yet unclassified' }
DijkstraAlgorithm >> dijkstraFrom: s [ 
	"The main function of the class. Runs the Dijkstra's algorithm the source vertex given by the argument s."
	| n infinity marked i breakOutOfLoop|
	
	n := self adjacencyList size.
	
	infinity := self getIntMaxValueFromC.
	
	marked := VectorStructure new newVectorWithNumberOfElements: n withValue: 0. "0 == false"
	
	self distancesVector: (VectorStructure new newVectorWithNumberOfElements: n withValue: infinity).
	
	self parentVector: (VectorStructure new newVectorWithNumberOfElements: n withValue: -1).
	
	self distancesVector setElement: 0 atIndex: s.
	
	i := 0.
	breakOutOfLoop := false.
	[ i < n and: breakOutOfLoop not] whileTrue: [ 
			| v |
			v := -1.
			
			0 to: n-1 do: [ :j |
						((marked elementAt: j) = 0) ifTrue: [ 
							((v = -1) or: ((self distancesVector elementAt: j) < (self distancesVector elementAt: v))) ifTrue: [ 
									v := j
							].
						].
			].
			
			((self distancesVector elementAt: v) = infinity) ifTrue: [ breakOutOfLoop := true ].
			
			breakOutOfLoop ifFalse: [  
					marked setElement: 1 atIndex: v. "1 == true"

					(self adjacencyListOfVertex: v+1) do: [ :edge |
							| to len |
							to := edge data first.
							len := edge data second.
							(((self distancesVector elementAt: v) + len) < (self distancesVector elementAt: to)) ifTrue: [ 
									self distancesVector setElement: ((self distancesVector elementAt: v) + len) atIndex: to.
									self parentVector setElement: v atIndex: to. 
							].	
					].		
			].	
			i := i + 1.
		].
]

{ #category : #accessing }
DijkstraAlgorithm >> distancesVector [

	^ distancesVector
]

{ #category : #accessing }
DijkstraAlgorithm >> distancesVector: anObject [

	distancesVector := anObject
]

{ #category : #'as yet unclassified' }
DijkstraAlgorithm >> fixDistancesVector [
		"6 4 5 9 11 0   --->   0 6 4 5 9 11"
		| fixedVector idx |
		
		fixedVector := VectorStructure new newVectorWithNumberOfElements: (self distancesVector size) withValue: 0.
		
		fixedVector setElement: 0 atIndex: 0.
		
		idx := 1.
		self distancesVector do: [ :elem |
				fixedVector setElement: elem atIndex: idx.
				idx := idx + 1
		].
		
		self distancesVector: fixedVector
]

{ #category : #'as yet unclassified' }
DijkstraAlgorithm >> fixParentVector [
		"2 0 2 3 4 0   --->   -1 2 0 2 3 4"
		
		| fixedVector idx |
		
		fixedVector := VectorStructure new newVectorWithNumberOfElements: (self parentVector size) withValue: -1.
		
		fixedVector setElement: -1 atIndex: 0.
		
		idx := 1.
		self parentVector do: [ :elem |
				fixedVector setElement: elem atIndex: idx.
				idx := idx + 1
		].
		
		self parentVector: fixedVector
]

{ #category : #tests }
DijkstraAlgorithm >> formatOutputOfVectors [
	"Returns a string describing the distancesVector and parentVector. The way the output string is formatted is for easy comparisson with the output string from the C implementation."
	| outputStr |
	
	outputStr := String new.
	outputStr := outputStr, 'D'.
	outputStr := outputStr, String cr, self distancesVector debugVector.
	
	outputStr := outputStr, String cr.
	outputStr := outputStr, 'P'.
	outputStr := outputStr, String cr, self parentVector debugVector.
	
	^ outputStr
]

{ #category : #tests }
DijkstraAlgorithm >> getIntMaxValueFromC [
	^ self ffiCall: #(int return_infinity(void)) library: (self class pathToLibrary).
]

{ #category : #initialization }
DijkstraAlgorithm >> initialize [
	self class pathToLibrary: '/Users/juanidoste/Downloads/dosteLib/libDijkstraC.dylib'.
	
	VectorStructure pathToLibrary: '/Users/juanidoste/Downloads/dosteLib/libVectorDoste.dylib'
]

{ #category : #accessing }
DijkstraAlgorithm >> parentVector [

	^ parentVector
]

{ #category : #accessing }
DijkstraAlgorithm >> parentVector: anObject [

	parentVector := anObject
]

{ #category : #tests }
DijkstraAlgorithm >> runDijkstraFromC [
	self ffiCall: #(void run_dijkstra(void)) library: (self class pathToLibrary).
]

{ #category : #initialization }
DijkstraAlgorithm >> setAdjacencyListFromString: anStringRepresentingTheAdjacencyList [
	
	self adjacencyList: (AdjacencyListBuilder new buildFromSource: anStringRepresentingTheAdjacencyList).
]

{ #category : #tests }
DijkstraAlgorithm >> test [
	"I couldn't delete it :facepalm:"
]
