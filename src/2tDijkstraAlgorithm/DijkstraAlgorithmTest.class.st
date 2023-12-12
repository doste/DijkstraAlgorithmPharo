"
This class contains tests. The idea is to test the Pharo implementation against the C implementation of the Dijkstra's algorithm.

 As with almost all the classes inside the 2tDijsktraAlgorithm package, the main goal is to learn. Specially I wanted to learn to use uFFI, so there are a lot of calls to C functions, even when it doesn't seem necessary. But again I wanted to learn (and also it is fun :))
"
Class {
	#name : #DijkstraAlgorithmTest,
	#superclass : #TestCase,
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #tests }
DijkstraAlgorithmTest >> testCaseOne [
	| djk inputC stringInputC stream outputFromPharo outputFromC |

	djk := DijkstraAlgorithm new.
	inputC := InputForCBuilder new.

	djk setAdjacencyListFromString: '0 -> [(1, 9), (2, 4)]
		1 -> [(0, 9), (2, 2), (3, 7), (4, 3)]
		2 -> [(0, 4), (1, 2), (3, 1), (4, 6)]
		3 -> [(1, 7), (2, 1), (4, 4), (5, 8)]
		4 -> [(1, 3), (2, 6), (3, 4), (5, 2)]
		5 -> [(3, 8), (4, 2)]'.
	
	"Here we run the Pharo implementation of the algorithm:"
	djk dijkstraFrom: 0.
	djk fixDistancesVector.
	djk fixParentVector.

	"We prepare the input for the C implementation, from the same input that the Pharo algorithm received."
	stringInputC := inputC buildInputFromSource: djk adjacencyList.
		
	(FileSystem disk workingDirectory / 'inputFromPharo.txt') writeStream nextPutAll: stringInputC ; close.
	
	"We run the C implementation:"
	djk runDijkstraFromC.
	"Its output will be in outputFromC.txt"

	"We read it:"
	stream := (FileSystem disk workingDirectory / 'outputFromC.txt') readStream.
	
	outputFromC := stream contents trim.
	
	outputFromC := outputFromC substrings.
	
	stream close.
	
	outputFromPharo := djk formatOutputOfVectors trim.
	
	outputFromPharo := outputFromPharo substrings.
	
	"And compare the boths results (we have to do a little of preprocessing of the both outputs so the comparisson ends up easier and doesn't have to deal
	with annoying details like whitespaces, formatting, etc.)"
	self assert: outputFromPharo equals: outputFromC.
	
]

{ #category : #tests }
DijkstraAlgorithmTest >> testCaseThree [
	| djk incpp stringInputC stream outputFromPharo outputFromC |

	djk := DijkstraAlgorithm new.
	incpp := InputForCBuilder new.

	djk setAdjacencyListFromString: '0 -> [(1, 3), (3, 4)]
		1 -> [(0, 3), (2, 4), (3, 6)]
		2 -> [(1, 4), (6, 2), (4, 7)]
		3 -> [(0, 4), (1, 6), (7, 7)]
		4 -> [(2, 7)]
		5 -> []
		6 -> [(2,2)]
		7 -> [(3, 7)]'.
	
	djk dijkstraFrom: 0.
	djk fixDistancesVector.
	djk fixParentVector.

	stringInputC := incpp buildInputFromSource: djk adjacencyList.
		
	(FileSystem disk workingDirectory / 'inputFromPharo.txt') writeStream nextPutAll: stringInputC ; close.
	
	djk runDijkstraFromC.
	"output will be in outputFromC.txt"

	stream := (FileSystem disk workingDirectory / 'outputFromC.txt') readStream.
	
	outputFromC := stream contents trim.
	
	outputFromC := outputFromC substrings.
	
	stream close.
	
	outputFromPharo := djk formatOutputOfVectors trim.
	
	outputFromPharo := outputFromPharo substrings.
	
	self assert: outputFromPharo equals: outputFromC.
	
]

{ #category : #tests }
DijkstraAlgorithmTest >> testCaseTwo [
	| djk inputC stringInputC stream outputFromPharo outputFromC |

	djk := DijkstraAlgorithm new.
	inputC := InputForCBuilder new.

	djk setAdjacencyListFromString: '0 -> [(1, 4), (7, 8)]
	1 -> [(0, 4), (7, 11), (2, 8)]
	2 -> [(1, 8), (3, 7), (5, 4), (8, 2)]
	3 -> [(2, 7), (4, 9), (5, 14)]
	4 -> [(3, 9), (5, 10)]
	5 -> [(2, 4), (3, 14), (4, 10), (6, 2)]
	6 -> [(5, 2), (7, 1), (8, 6)]
	7 -> [(0, 8), (1, 11), (6, 1), (8, 6)]
	8 -> [(2, 2), (6, 6), (7, 7)]'.
	
	"Here we run the Pharo implementation of the algorithm:"
	djk dijkstraFrom: 0.
	djk fixDistancesVector.
	djk fixParentVector.

	"We prepare the input for the C implementation, from the same input that the Pharo algorithm received."
	stringInputC := inputC buildInputFromSource: djk adjacencyList.
		
	(FileSystem disk workingDirectory / 'inputFromPharo.txt') writeStream nextPutAll: stringInputC ; close.
	
	"We run the C implementation:"
	djk runDijkstraFromC.
	"Its output will be in outputFromC.txt"

	"We read it:"
	stream := (FileSystem disk workingDirectory / 'outputFromC.txt') readStream.
	
	outputFromC := stream contents trim.
	
	outputFromC := outputFromC substrings.
	
	stream close.
	
	outputFromPharo := djk formatOutputOfVectors trim.
	
	outputFromPharo := outputFromPharo substrings.
	
	"And compare the boths results (we have to do a little of preprocessing of the both outputs so the comparisson ends up easier and doesn't have to deal
	with annoying details like whitespaces, formatting, etc.)"
	self assert: outputFromPharo equals: outputFromC.
	
]
