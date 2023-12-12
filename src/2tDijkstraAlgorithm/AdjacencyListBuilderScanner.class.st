"
I build an Adjacency List.

You give me something like this: 
		0 -> [(1, 2)]
		1 -> [(0, 2), (2, 11)]
		2 -> [(1, 11)]
And I give you an Array of LinkedLists where each LinkedList corresponds to one of the vertex.
 Each node of the List is a Pair: the first field represents the neighbor of the vertex, and the second field is the weight/length of that edge.
"
Class {
	#name : #AdjacencyListBuilderScanner,
	#superclass : #Object,
	#instVars : [
		'arrayOfEntries',
		'source',
		'start',
		'current',
		'line',
		'tokens'
	],
	#category : #'2tDijkstraAlgorithm'
}

{ #category : #scanning }
AdjacencyListBuilderScanner >> addTokenWithType: type [

		self addTokenWithType: type withLiteral: nil.
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> addTokenWithType: type withLiteral: literal [

		| text newToken|
		
		text := self source copyFrom: (self start) to: (self current - 1).
		
		newToken := DosteToken withType: type withLexeme: text  withLiteral: literal  withLine: self line.
	
		self tokens add: newToken.
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> advance [
		"Consumes the next character in the source file and returns it."
		| charAtCurrentPosition |
		
		charAtCurrentPosition := self source at: (self current).
		
		self current: self current + 1.
		
		^ charAtCurrentPosition 

	
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> arrayOfEntries [

	^ arrayOfEntries
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> arrayOfEntries: anObject [

	arrayOfEntries := anObject
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> build: aString [

	| anArray index firstElem secondElem|
	
	anArray := Array new: (aString lineCount).
	
	index := 1.
	[ index < aString size ] whileTrue: [  
        "here `aString at: index` is the current character of the string"
			| currentChar |
			currentChar := aString at: index.
			currentChar isNumber ifTrue: [ anArray at: currentChar asNumber put: DosteLinkedList new ].
			
			[ currentChar equals: Character space ] whileTrue: [ currentChar := aString at: index . index := index + 1 ].
		
			index := self consumeArrow: aString withCursor: index.
		
			[ currentChar equals: Character space ] whileTrue: [ currentChar := aString at: index . index := index + 1 ].
		
			(currentChar equals: $]) whileTrue: [ 
					index := self consumeLeftBracket: aString withCursor: index.
					index := self consumeLeftParent: aString withCursor: index.
					firstElem := aString at: index.
					index := self consumeColon: aString withCursor: index.
					secondElem := aString at: index.
					DosteLLNode new data: (Pair new first: firstElem second: secondElem).
					index := self consumeRightParent: aString withCursor: index.
					
					currentChar := aString at: index . index := index + 1
			].
		
			[ currentChar equals: Character cr ] whileFalse: [ currentChar := aString at: index . index := index + 1 ].
		
		
			index := index + 1
   ].

	
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> current [

	^ current
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> current: anObject [

	current := anObject
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> debugTokens: tokenList [
		"Returns a string containing one token for line. Just for debugging purposes"

		| stringOfTokens |
		
		stringOfTokens := String new.
		
		tokenList  do:[ :tok | stringOfTokens := stringOfTokens, tok data toString, String cr ].
		
		stringOfTokens := stringOfTokens, 'ENDDebug'.
		
		^ stringOfTokens 
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> getTokensFromSource: aString [

		self source: aString.
		
		^ self scanTokens.
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> handleNumber [
	| numberInSubstring |

	[(self peek) isNotNil and: [(self peek) isDigit]] whileTrue: [ 
			self advance
	].


	numberInSubstring := self source copyFrom: (self start) to: (self current - 1).
	self addTokenWithType: #Number withLiteral: numberInSubstring asNumber.
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> initialize [
		super initialize.
		
		start := 1.
		current := 1.
		line := 1.
		
		tokens := DosteLinkedList new.
		
		arrayOfEntries := Array new.
		
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> isAtEnd [
	
		^ self current > self source size
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> keywords [

	^ keywords
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> keywords: anObject [

	keywords := anObject
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> line [

	^ line
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> line: anObject [

	line := anObject
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> match: expected [
		"It's like a conditional advance(). We only consume the character if it's what we are looking for."
		
		| charAtCurrentPosition |

		self isAtEnd ifTrue: [ ^ false ].
		
		charAtCurrentPosition := self source at: (self current).
		
		charAtCurrentPosition = expected ifFalse: [ ^ false ].
		
		self current: self current + 1.
		
		^ true.
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> peek [ 

		| charAtCurrentPosition |

		self isAtEnd ifTrue: [ ^ nil ].
		
		charAtCurrentPosition := self source at: (self current).
		
		^ charAtCurrentPosition.
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> scanToken [

		| currentChar tokenAddedSuccessfully|
		
		currentChar := self advance.
		
		currentChar = $( ifTrue: [ ^ self addTokenWithType: #LeftParen ].
		currentChar = $) ifTrue: [ ^ self addTokenWithType: #RightParen ].
		currentChar = $[ ifTrue: [ ^ self addTokenWithType: #LeftBracket ].
		currentChar = $] ifTrue: [ ^ self addTokenWithType: #RightBracket ].
		currentChar = $, ifTrue: [ ^ self addTokenWithType: #Comma ].	
		tokenAddedSuccessfully := self scanTokenCharacter: currentChar ToMatch: $- With: $> ForTokenType: #Arrow.
		tokenAddedSuccessfully ifNotNil: [^ tokenAddedSuccessfully ].
		
		currentChar isSpaceSeparator  ifTrue: [ ^ nil ].
		
		((currentChar = Character cr) or: currentChar = Character tab) ifTrue: [
				self line: self line + 1.
				^ nil ].

		currentChar isDigit ifTrue: [ ^ self handleNumber ].
		
		self error: 'Unexpected character.'.
		^ nil 
		
		
		
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> scanTokenCharacter: character ToMatch: firstCharacterToMatch With: secondCharacterToMatch ForTokenType: type [

		character = firstCharacterToMatch ifTrue: [ (self match: secondCharacterToMatch) ifTrue: [ 
																								^ self addTokenWithType: type
				 															]
		].
	
	
	^ nil
		
		
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> scanTokens [
		| newToken |
		
		[self isAtEnd] whileFalse: [ 
				self start: self current.
				self scanToken
		].
	
     "Ÿ al final agregamos el token EndOfFile"								
		newToken := DosteToken new.
		newToken type: #EOF.
		newToken lexeme: ''.
		newToken literal: nil.
		newToken line: self line.
	
		self tokens add: newToken.
		
		^ self tokens
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> source [

	^ source
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> source: anObject [

	source := anObject
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> start [

	^ start
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> start: anObject [

	start := anObject
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> tokens [

	^ tokens
]

{ #category : #scanning }
AdjacencyListBuilderScanner >> tokens: anObject [

	tokens := anObject
]
