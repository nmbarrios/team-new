Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BoardTest >> testCreatingBoardWithInvalidAmountOfSpaces [
	| board |
	self
		should: [ board := Board
				withSpaces: -30
				andEffectsGeneratedFrom:
					{NoEffect new.
					AtomicBombEffect new} ]
		raise: MatchException 
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'you can not create a board with less than 1 space' ]
]

{ #category : #tests }
BoardTest >> testCreatingBoardWithRandomStrategy [
	| board |
	board := Board withRandomEffectsAndSpaces: 50.
	self
		assert: (board effects allSatisfy: [ :effect | effect respondsTo: #turnOnEffectAt:activatedBy: ])
]

{ #category : #tests }
BoardTest >> testCreatingBoardWithValidAmountOfSpaces [
	| board |
	board := Board
		withSpaces: 30
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	self assert: board spaces equals: 30
]

{ #category : #tests }
BoardTest >> testCreatingDeterministicBoardWithAnEmptyEffectSuccession [
	| board |
	self should: [
	board := Board withSpaces: 10 andEffectsGeneratedFrom: {  }]
	raise: MatchException 
	withExceptionDo: [ :exception | self assert: exception messageText equals: 'The effect succession must have at least one effect' ]
	
]
