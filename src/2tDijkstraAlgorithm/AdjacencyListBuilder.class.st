"
I am responsible for building an adjacency list representing a weighted graph.
	I receive a string containing all the vertex and edges information and build a data structure to represent the graph they describe.
	
To do that two other classes help me. The Scanner and the Parser classes:
	The Scanner class, as the name implies, scan the input string and tokenize it. It outputs tokens, which will be input for the Parser.
	The Parser class is where the building per se happens. This class is responsible for building the actual data structure representing the graph described by the tokens.
"
Class {
	#name : #AdjacencyListBuilder,
	#superclass : #Object,
	#instVars : [
		'scanner',
		'parser',
		'source'
	],
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #initialization }
AdjacencyListBuilder >> buildFromSource: aString [

		| listOfTokens |
			
		listOfTokens := self scanner getTokensFromSource: aString.
		
		self parser arrayOfEntries: (Array new: (aString lineCount)).
		
		self parser tokens: listOfTokens.
		
		self parser parse.
		
		^ self parser arrayOfEntries
		
		
]

{ #category : #initialization }
AdjacencyListBuilder >> debugArrayOfEntries [
		
		| copyOfArrayOfEntries i stringDescription |
		
		stringDescription := String new.
		
		copyOfArrayOfEntries := self parser arrayOfEntries reject: [ :llist |  llist isNil ].
		
		copyOfArrayOfEntries := copyOfArrayOfEntries reject: [ :llist | llist isEmpty].
		
		i := 0.
		
		copyOfArrayOfEntries do: [ :llist | stringDescription := stringDescription, i asString.
																				stringDescription := stringDescription, ' -> [ '.
																				llist ifNotNil: [llist asOrderedCollection do: [ :node |  
																																									stringDescription := stringDescription, '('.
																							                                          stringDescription := stringDescription, node first asString.
																																									stringDescription := stringDescription, ', '.
																																									stringDescription := stringDescription, node second asString.
																																									stringDescription := stringDescription, ') '.
																						].
																					stringDescription := stringDescription, ']'.
																					stringDescription := stringDescription, String cr.
																				]. 
																				
																				i := i + 1
		].
		
		stringDescription := stringDescription, String cr, 'ENDDebug'.
		
		
		^ stringDescription
]

{ #category : #initialization }
AdjacencyListBuilder >> initialize [
		
		scanner := AdjacencyListBuilderScanner new.
		
		parser := AdjacencyListBuilderParser new.
]

{ #category : #accessing }
AdjacencyListBuilder >> parser [

	^ parser
]

{ #category : #accessing }
AdjacencyListBuilder >> parser: anObject [

	parser := anObject
]

{ #category : #accessing }
AdjacencyListBuilder >> scanner [

	^ scanner
]

{ #category : #accessing }
AdjacencyListBuilder >> scanner: anObject [

	scanner := anObject
]

{ #category : #accessing }
AdjacencyListBuilder >> source [

	^ source
]

{ #category : #accessing }
AdjacencyListBuilder >> source: anObject [

	source := anObject
]
