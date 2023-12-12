Class {
	#name : #AdjacencyListBuilderParser,
	#superclass : #Object,
	#instVars : [
		'arrayOfEntries',
		'tokens',
		'current'
	],
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #parsing }
AdjacencyListBuilderParser >> advance [
		
		(self isAtEnd) ifFalse: [ self incrementCurrent  ].
		
		^ self previous
	
	
	
]

{ #category : #accessing }
AdjacencyListBuilderParser >> arrayOfEntries [

	^ arrayOfEntries
]

{ #category : #accessing }
AdjacencyListBuilderParser >> arrayOfEntries: anObject [

	arrayOfEntries := anObject
]

{ #category : #accessing }
AdjacencyListBuilderParser >> check: tokenTypeToCompare [
		"Consumes the current token and returns it."
		| tokenPeeked |
		
		(self isAtEnd) ifTrue: [ ^ false  ].
		
		tokenPeeked := self peek.
		
		^ (tokenPeeked type) = tokenTypeToCompare 
	
]

{ #category : #parsing }
AdjacencyListBuilderParser >> consume: aTokenTypeToConsume [
		
		"Similar to match() in that it checks to see if the next token is of the expected type.
    	If so, it consumes the token and everything if fine.
    	If some other token is there, then we've hit an error."
	
		| tokenPeeked |
		
		(self isAtEnd) ifTrue: [ ^ nil  ].
		
		tokenPeeked := self peek.
		
		(tokenPeeked data type = aTokenTypeToConsume) ifTrue: [self advance ].

]

{ #category : #accessing }
AdjacencyListBuilderParser >> current [

	^ current
]

{ #category : #accessing }
AdjacencyListBuilderParser >> current: anObject [

	current := anObject
]

{ #category : #parsing }
AdjacencyListBuilderParser >> incrementCurrent [
		
		self current: self current + 1.
	
]

{ #category : #initialization }
AdjacencyListBuilderParser >> initialize [

		super initialize.
		current := 1.
		
		"arrayOfEntries := Array new."
		
		"The Parser will expect the List of Tokens as a parameter, it will not have to build one".
]

{ #category : #parsing }
AdjacencyListBuilderParser >> isAtEnd [
		| tokenPeeked |
		
		tokenPeeked := self peek.
		
		"tokenPeeked type = #EOF ifTrue: [ ^ true ] ifFalse: [ ^ false ]."
		
		^ (tokenPeeked data type = #EOF)
	
]

{ #category : #parsing }
AdjacencyListBuilderParser >> match: aTokenTypeToMatch [
		| tokenPeeked |
		
		"This check to see if the current token has the same type as aTokenTypeToMatch.
      If so, consumes the token and returns true.
      If not, it returns false and leaves the current token alone."

		(self isAtEnd) ifTrue: [ ^ false  ].
		
		tokenPeeked := self peek.
		
		((tokenPeeked data type) = aTokenTypeToMatch) ifTrue: [ self advance. ^ true ].
		
		^ false
		
	
]

{ #category : #parsing }
AdjacencyListBuilderParser >> parse [
		| rows |
		
		"rows := DosteLinkedList new."
		
		"self halt."
		[ self isAtEnd ] whileFalse: [ 
				"rows add: self parseRow"
				self parseRow
		].
	
		"^ rows"
	
]

{ #category : #parsing }
AdjacencyListBuilderParser >> parseNumber [
		| number |
		
		(self match: 'Number') ifTrue: [ number :=  self previous . self advance ].
		
		number := number data lexeme asString asInteger.
	
		^ number
]

{ #category : #parsing }
AdjacencyListBuilderParser >> parsePair [
	"Grammar Rule: 
			pair   -> ""("" ""first"" "","" ""second"" "")"" ;"
		
		| firstNumber secondNumber |
		
		self consume: #LeftParen.
		
		firstNumber := self parseNumber.
		
		self consume: #Comma.
		
		secondNumber := self parseNumber.
		
		self consume: #RightParen.
		
		^ Pair new first: firstNumber; second: secondNumber
		
]

{ #category : #parsing }
AdjacencyListBuilderParser >> parseRow [
		"Grammar Rule: 
			row   -> ""numberOfEntry"" ""->"" ""["" ""("" pair "")""*?   ""]"" ;"
		
		| numberOfEntry pair listOfPairs|
		
		listOfPairs := DosteLinkedList new.
	
		numberOfEntry := self parseNumber.
		
		self consume: #Arrow.
		
		self consume: #LeftBracket.
		
		(self peek data type = #LeftParen) ifTrue: [ 
		
			pair := self parsePair.
		
			listOfPairs add: pair.
		
			[self match: #Comma] whileTrue: [ pair := self parsePair . listOfPairs add: pair ].
		
		].
		self consume: #RightBracket.
		
		self arrayOfEntries at: (numberOfEntry + 1) put: listOfPairs.
		
]

{ #category : #parsing }
AdjacencyListBuilderParser >> peek [
		
		^ (self tokens) getAt: (self current - 1).
	
	
]

{ #category : #accessing }
AdjacencyListBuilderParser >> previous [
		
		"Returns the most recently consumed token.
      This method makes it easier to use match() and then access the just-matched token (see body of equality())"

		^ (self tokens) getAt: (self current - 2)
		
]

{ #category : #accessing }
AdjacencyListBuilderParser >> tokens [

	^ tokens
]

{ #category : #accessing }
AdjacencyListBuilderParser >> tokens: anObject [

	tokens := anObject
]
