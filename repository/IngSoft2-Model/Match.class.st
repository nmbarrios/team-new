Class {
	#name : #Match,
	#superclass : #Object,
	#instVars : [
		'board',
		'players',
		'dices',
		'positionOfPlayers',
		'playerIndex',
		'totalLaps',
		'deck',
		'lastEffect',
		'lastCard',
		'playersCards',
		'cardsActivated',
		'discardDeck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Match class >> playedBy: thePlayers throwing: gameDices during: aNumberOfLaps on: aBoard dealingFrom: aDeck [
	^ self new
		initializePlayedBy: thePlayers
		throwing: gameDices
		during: aNumberOfLaps
		on: aBoard
		dealingFrom: aDeck
]

{ #category : #adding }
Match >> add: aCard toBeAppliedTo: aPlayer [
	(cardsActivated at: aCard ifAbsentPut: [ OrderedCollection new ] ) add: aPlayer
]

{ #category : #adding }
Match >> addToDiscardDeck: aCard [
	discardDeck addFromMatch: aCard
]

{ #category : #description }
Match >> assert: aPlayer owns: aCard [
	(self cardsOf: aPlayer)
		detect: [ :card | card = aCard ]
		ifNone: [ MatchException signal: 'The player ' , aPlayer name , ' do not own ' , aCard className ]
]

{ #category : #description }
Match >> assertIsPlaying: aPlayer [
	(players includes: aPlayer)
		ifFalse: [ MatchException signal: 'Player ' , aPlayer name , ' is not playing' ]
]

{ #category : #description }
Match >> assertMatchHasEnded [
	self matchNotEnded
		ifFalse: [ MatchException signal: 'The match is over' ]
]

{ #category : #description }
Match >> assertTurnBelongsTo: aPlayer [
	aPlayer = self nextPlayer
		ifFalse: [ MatchException signal: 'It is not ' , aPlayer name , ' turn' ]
]

{ #category : #accessing }
Match >> cardsOf: aPlayer [
	self assertIsPlaying: aPlayer.
	^ playersCards at: aPlayer
]

{ #category : #accessing }
Match >> cardsOfDiscardDeck [
	^ discardDeck cards
]

{ #category : #accessing }
Match >> cardsTargeting: aPlayer [
	^ (cardsActivated select: [ :targetedPlayers | targetedPlayers includes: aPlayer ]) keys
]

{ #category : #playing }
Match >> changeTurn [
	playerIndex := (playerIndex rem: players size) + 1
]

{ #category : #playing }
Match >> dealCardFromShuffledDeckTo: aPlayer [
	^ [ deck generatedFrom: discardDeck shuffled.
	self dealCardTo: aPlayer ]
		on: MatchException
		do: [  ]
]

{ #category : #playing }
Match >> dealCardTo: aPlayer [
	(playersCards at: aPlayer ifAbsent: [ playersCards add: aPlayer -> OrderedCollection new ]) add: deck dealCard
]

{ #category : #playing }
Match >> dealInitialHandTo: player [
	playersCards at: player put: OrderedCollection new.
	[ (playersCards at: player) add: deck dealCard ]
		on: MatchException
		do: [  ].
	^ [ (playersCards at: player) add: deck dealCard ]
		on: MatchException
		do: [  ]
]

{ #category : #accessing }
Match >> hasWon: aPlayer [
	^ (self positionOf: aPlayer) currentLap > (totalLaps - 1)
]

{ #category : #initialization }
Match >> initializePlayedBy: thePlayers throwing: theDices during: aNumberOfLaps on: aBoard dealingFrom: aDeck [
	players := thePlayers asOrderedCollection.
	playerIndex := 1.
	dices := theDices.
	totalLaps := aNumberOfLaps.
	board := aBoard.
	deck := aDeck.
	discardDeck := DiscardDeck new.
	positionOfPlayers := Dictionary new.
	cardsActivated := Dictionary new.
	playersCards := Dictionary new.
	players do:
		[ :player | self dealInitialHandTo: player ].
	lastCard := NoneCard new.
	lastEffect := players first -> NoEffect new
]

{ #category : #accessing }
Match >> lastCard [
	^ lastCard
]

{ #category : #accessing }
Match >> lastEffect [
	^ lastEffect value
]

{ #category : #accessing }
Match >> lastEffectTarget [
	^ lastEffect key
]

{ #category : #accessing }
Match >> matchNotEnded [
	^ players noneSatisfy: [ :player | self hasWon: player ]
]

{ #category : #moving }
Match >> move: aPlayer [
	self assertTurnBelongsTo: aPlayer.
	positionOfPlayers at: aPlayer put: self nextPlayerPosition
]

{ #category : #moving }
Match >> moveByEffectTo: aPlayer spaces: anAmountOfSpaces [
	positionOfPlayers
		at: aPlayer
		put:
			(Position
				whenMoving: anAmountOfSpaces
				from: (self positionOf: aPlayer)
				onBoardOfSize: board spaces)
]

{ #category : #accessing }
Match >> nextPlayer [
	^ players at: playerIndex
]

{ #category : #playing }
Match >> nextPlayerPosition [
	| nextPlayer |
	nextPlayer := self nextPlayer.
	^ Position
		whenMoving: (self throwDicesAndApplyCardsBy: nextPlayer)
		from: (self positionOf: nextPlayer)
		onBoardOfSize: board spaces
]

{ #category : #playing }
Match >> play: aCard by: aPlayer [
	self assertMatchHasEnded.
	self assert: aPlayer owns: aCard.
	aCard assertCanBePlayedBy: aPlayer in: self.
	aCard applyIn: self to: aPlayer.
	self remove: aCard fromHandOf: aPlayer.
	
]

{ #category : #playing }
Match >> play: aCard by: aPlayer targeting: anActivatedCard [
	self assertMatchHasEnded.
	self assert: aPlayer owns: aCard.
	aCard assertCanBePlayedBy: aPlayer in: self.
	aCard applyIn: self to: anActivatedCard.
	self remove: aCard fromHandOf: aPlayer
]

{ #category : #playing }
Match >> play: aCard targeting: anAffectedPlayer by: anAffecterPlayer [
	self assertMatchHasEnded.
	self assert: anAffecterPlayer owns: aCard.
	self assertIsPlaying: anAffectedPlayer.
	aCard assertCanBePlayedBy: anAffecterPlayer in: self.
	aCard applyIn: self to: anAffectedPlayer.
	self remove: aCard fromHandOf: anAffecterPlayer
]

{ #category : #playing }
Match >> playedBy: aPlayer [
	self assertIsPlaying: aPlayer.
	self assertMatchHasEnded.
	self move: aPlayer.
	[ board
		applyEffectOf: (self positionOf: aPlayer) currentSpace
		in: self
		activatedBy: aPlayer ]
		on: MatchException
		do:
			[ self dealCardFromShuffledDeckTo: aPlayer ].
	self changeTurn
]

{ #category : #accessing }
Match >> players [
	^ players
]

{ #category : #accessing }
Match >> positionOf: aPlayer [
	self assertIsPlaying: aPlayer.
	^ positionOfPlayers at: aPlayer ifAbsentPut: [ Position atStart ]
]

{ #category : #accessing }
Match >> rankingOf: aPlayer [
	self assertIsPlaying: aPlayer.
	^ (players asSortedCollection: [ :player | self positionOf: player ] descending) indexOf: aPlayer
]

{ #category : #removing }
Match >> remove: aCard fromHandOf: aPlayer [
	(playersCards at: aPlayer) remove: aCard
]

{ #category : #removing }
Match >> removeActivated: card [
	cardsActivated removeKey: card ifAbsent: [ MatchException signal: 'There is not a ' , card className , ' activated' ]
]

{ #category : #playing }
Match >> throwDicesAndApplyCardsBy: aPlayer [
	^ (self cardsTargeting: aPlayer)
		inject: (aPlayer throw: dices)
		into: [ :roll :card | card affectDiceRoll: roll ]
]

{ #category : #updating }
Match >> updateLastCard: aCard [
	lastCard := aCard
]

{ #category : #updating }
Match >> updateLastEffect: anEffectToPlayer [
	lastEffect := anEffectToPlayer
]

{ #category : #accessing }
Match >> winner [
	self matchNotEnded
		ifTrue: [ MatchException signal: 'There is no winner' ].
	^ players detect: [ :player | self hasWon: player ]
]
