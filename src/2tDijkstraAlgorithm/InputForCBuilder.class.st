"
I'm a utility class for testing the DijkstraAlgorithm class.
 
I convert input for the DijkstraAlgorithm class to an input that is 'digestible' for the C function that the tester will call.

Basically, I convert this:
	0 -> [(1, 9), (2, 4)]
	1 -> [(0, 9), (2, 2), (3, 7), (4, 3)]
	2 -> [(0, 4), (1, 2), (3, 1), (4, 6)]
	3 -> [(1, 7), (2, 1), (4, 4), (5, 8)]
	4 -> [(1, 3), (2, 6), (3, 4), (5, 2)]
	5 -> [(3, 8), (4, 2)]

IMPORTANT: the input I receive is *not* an string, it's the actual array of entries that the AdjacencyListBuilder outputs

into this:
	6
	2 1 9 2 4
	4 0 9 2 2 3 7 4 3
	4 0 4 1 2 3 1 4 6
	4 1 7 2 1 4 4 5 8
	4 1 3 2 6 3 4 5 2
	2 3 8 4 2
(The first number is the number of entries, and after, for each row, the first number indicates how many pairs that row has, and then the actual pairs).

My output *is* a string. This is so because the C implementation of the algorithm receives its input from a text file. So the tester will generate said text file from the String I output.
"
Class {
	#name : #InputForCBuilder,
	#superclass : #Object,
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #'as yet unclassified' }
InputForCBuilder >> buildInputFromSource: anArrayOfEntries [
		
		| stringOutput |
		
		stringOutput := String new.
		
		stringOutput := stringOutput, anArrayOfEntries size asString, String cr.
		
		anArrayOfEntries do: [ :entryList |
				entryList ifNotNil: [  
					stringOutput := stringOutput, entryList size asString, String space.	
					entryList do: [ :node | 
							stringOutput := stringOutput, node data first asString, String space.	
							stringOutput := stringOutput, node data second asString, String space.	
					].
					stringOutput := stringOutput, String cr.
				].
		].
	
		 ^ stringOutput 
]
