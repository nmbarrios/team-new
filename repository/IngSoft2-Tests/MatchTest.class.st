"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MatchTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
MatchTest >> boardWith10SpacesWithoutEffects [
	^ Board
		withSpaces: 10
		andEffectsGeneratedFrom: {NoEffect new}
]

{ #category : #accessing }
MatchTest >> deckWithOverloadCard [
	^ Deck
		deterministicWithCardSequence: {OverloadCard new}
		andAmountOfCards: 50
]

{ #category : #accessing }
MatchTest >> playerNamedFabio [
	^ Player named: 'Fabio'
]

{ #category : #accessing }
MatchTest >> playerNamedJuan [
	^ Player named: 'Juan'
]

{ #category : #accessing }
MatchTest >> playerNamedMartin [
	^ Player named: 'Martin'
]

{ #category : #tests }
MatchTest >> testAPlayerSkipsMoreThanOneLapInASingleThrow [
	| fabio match dices board players deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	fabio := self playerNamedFabio.
	players := OrderedCollection with: fabio.
	dices := OrderedCollection
		with: (Dice deterministicWithFaces: 20 throwing: #(20)).
	match := Match
		playedBy: players
		throwing: dices
		during: 4
		on: board
		dealingFrom: deck.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 1.
	self assert: (match positionOf: fabio) currentLap equals: 2
]

{ #category : #tests }
MatchTest >> testAPlayerWantsToPlayACardHeDoesNotHave [
	| juan jose board dice deck match speedCard overloadCard |
	juan := self playerNamedJuan.
	jose := Player named: 'Jose'.
	board := self boardWith10SpacesWithoutEffects.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	deck := Deck
		deterministicWithCardSequence: {overloadCard}
		andAmountOfCards: 50.
	dice := Dice deterministicWithFaces: 6 throwing: {2 . 6}.
	match := Match
		playedBy:
			{juan.
			jose}
		throwing: {dice}
		during: 3
		on: board
		dealingFrom: deck.
	self
		assert: (match cardsOf: juan)
		equals:
			{overloadCard.
			overloadCard} asOrderedCollection.
	self
		should: [ match play: speedCard targeting: jose by: juan ]
		raise: MatchException
		withExceptionDo: [ :exception | 
			self
				assert: exception messageText
				equals: 'The player Juan do not own SpeedCard' ]
]

{ #category : #tests }
MatchTest >> testAPlayerWantsToPlayButHeIsNotPartOfTheMatch [
	| fabio cristian match board dices players deck |
	deck := self deckWithOverloadCard.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 5 throwing: #(5)).
	board := Board
		withSpaces: 10
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	fabio := self playerNamedFabio.
	cristian := Player named: 'Cristian'.
	players := OrderedCollection with: fabio.
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	match playedBy: fabio.
	self
		should: [ match playedBy: cristian ]
		raise: MatchException
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'Player ' , cristian name , ' is not playing' ]
]

{ #category : #tests }
MatchTest >> testAPlayerWantsToPlayWhenItIsNotHisTurn [
	| match board martin juan dices players deck |
	deck := self deckWithOverloadCard.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	martin := self playerNamedMartin.
	juan := self playerNamedJuan.
	players := OrderedCollection with: martin with: juan.
	dices := OrderedCollection
		with: (Dice deterministicWithFaces: 6 throwing: #(1 3)).
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	match playedBy: martin.
	self assert: match nextPlayer equals: juan.
	match playedBy: juan.
	self
		should: [ match playedBy: juan ]
		raise: MatchException
		withExceptionDo:
			[ :exception | self assert: exception messageText equals: 'It is not Juan turn' ]
]

{ #category : #tests }
MatchTest >> testAPlayerWantsToPlayWhenMatchIsOver [
	| fabio match board players dices deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	fabio := self playerNamedFabio.
	players := OrderedCollection with: fabio.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 7 throwing: #(4 7)).
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	match playedBy: fabio.
	self
		assert: (match positionOf: fabio) currentSpace equals: 5;
		assert: (match positionOf: fabio) currentLap equals: 0.
	match playedBy: fabio.
	self
		should: [ match playedBy: fabio ]
		raise: MatchException
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'The match is over' ]
]

{ #category : #tests }
MatchTest >> testAPlayerWins [
	| match board martin dices players deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	martin := self playerNamedMartin.
	players := OrderedCollection with: martin.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(6 4)).
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 7;
		assert: (match positionOf: martin) currentLap equals: 0.
	match playedBy: martin.
	self assert: match winner name equals: 'Martin'
]

{ #category : #tests }
MatchTest >> testAPlayerWinsInAGameWithMoreThanOneLap [
	| fabio match dices board players deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	fabio := self playerNamedFabio.
	players := OrderedCollection with: fabio.
	dices := OrderedCollection
		with: (Dice deterministicWithFaces: 5 throwing: #(4 2 5))
		with: (Dice deterministicWithFaces: 6 throwing: #(3 6 1)).
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	match playedBy: fabio.
	self
		assert: (match positionOf: fabio) currentSpace equals: 8;
		assert: (match positionOf: fabio) currentLap equals: 0.
	match playedBy: fabio.
	self
		assert: (match positionOf: fabio) currentSpace equals: 6;
		assert: (match positionOf: fabio) currentLap equals: 1.
	match playedBy: fabio.
	self
		assert: (match positionOf: fabio) currentSpace equals: 2;
		assert: (match positionOf: fabio) currentLap equals: 2;
		assert: match winner equals: fabio
]

{ #category : #tests }
MatchTest >> testAllCardsAndAllEfectsInOneMatch [
	| martin fabio juan dice board deck overloadCard speedCard accelerationCard cancellationCard repeatCard redoCard match |
	juan := self playerNamedJuan.
	fabio := self playerNamedFabio.
	martin := self playerNamedMartin.
	dice := Dice
		deterministicWithFaces: 7
		throwing: {3 . 6 . 7 . 2 . 3 . 6}.
	board := Board
		withSpaces: 30
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new.
			(MoonWalkEffect moving: 2).
			SpeedUpEffect new.
			WormHoleEffect new}.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	accelerationCard := AccelerationCard new.
	cancellationCard := CancellationCard new.
	repeatCard := RepeatCard new.
	redoCard := RedoCard new.
	deck := Deck
		deterministicWithCardSequence:
			{overloadCard.
			speedCard.
			accelerationCard.
			cancellationCard.
			repeatCard.
			redoCard}
		andAmountOfCards: 50.
	match := Match
		playedBy:
			{juan.
			fabio.
			martin}
		throwing: {dice}
		during: 4
		on: board
		dealingFrom: deck.
	match play: overloadCard targeting: fabio by: juan.
	self
		assert: (match cardsOf: juan)
		equals: {speedCard} asOrderedCollection.
	match playedBy: juan.
	self assert: (match positionOf: juan) currentSpace equals: 8.
	match play: accelerationCard by: fabio.
	self
		assert: (match cardsOf: fabio)
		equals: {cancellationCard} asOrderedCollection.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 6.
	match play: redoCard by: martin.
	self
		assert: (match cardsOf: martin)
		equals: {repeatCard} asOrderedCollection.
	match playedBy: martin.
	self assert: (match positionOf: martin) currentSpace equals: 6.
	match play: speedCard targeting: juan by: juan.
	self assert: (match cardsOf: juan) equals: {} asOrderedCollection.
	match play: cancellationCard by: fabio targeting: overloadCard.
	self assert: (match cardsOf: fabio) equals: {} asOrderedCollection.
	match playedBy: juan.
	self assert: (match positionOf: juan) currentSpace equals: 13.
	self assert: (match positionOf: fabio) currentSpace equals: 4.
	self assert: (match positionOf: martin) currentSpace equals: 4.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 13.
	match play: repeatCard by: martin.
	self assert: (match cardsOf: martin) equals: {} asOrderedCollection.
	self assert: (match positionOf: fabio) currentSpace equals: 17.
	match playedBy: martin.
	self assert: (match positionOf: juan) currentSpace equals: 1.
	self assert: (match positionOf: fabio) currentSpace equals: 1.
	self assert: (match positionOf: martin) currentSpace equals: 1
]

{ #category : #tests }
MatchTest >> testAllCardsInOneMatch [
	| martin fabio juan dice board deck overloadCard speedCard accelerationCard cancellationCard repeatCard redoCard match |
	juan := self playerNamedJuan.
	fabio := self playerNamedFabio.
	martin := self playerNamedMartin.
	dice := Dice deterministicWithFaces: 6 throwing: {3}.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			SpeedUpEffect new}.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	accelerationCard := AccelerationCard new.
	cancellationCard := CancellationCard new.
	repeatCard := RepeatCard new.
	redoCard := RedoCard new.
	deck := Deck
		deterministicWithCardSequence:
			{overloadCard.
			speedCard.
			accelerationCard.
			cancellationCard.
			repeatCard.
			redoCard}
		andAmountOfCards: 50.
	match := Match
		playedBy:
			{juan.
			fabio.
			martin}
		throwing: {dice}
		during: 4
		on: board
		dealingFrom: deck.
	match play: overloadCard targeting: fabio by: juan.
	self
		assert: (match cardsOf: juan)
		equals: {speedCard} asOrderedCollection.
	match playedBy: juan.
	self assert: (match positionOf: juan) currentSpace equals: 8.
	match play: accelerationCard by: fabio.
	self
		assert: (match cardsOf: fabio)
		equals: {cancellationCard} asOrderedCollection.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 3.
	match play: redoCard by: martin.
	self
		assert: (match cardsOf: martin)
		equals: {repeatCard} asOrderedCollection.
	match playedBy: martin.
	self assert: (match positionOf: martin) currentSpace equals: 10.
	match play: speedCard targeting: juan by: juan.
	self assert: (match cardsOf: juan) equals: {} asOrderedCollection.
	match play: cancellationCard by: fabio targeting: overloadCard.
	self assert: (match cardsOf: fabio) equals: {} asOrderedCollection.
	match playedBy: juan.
	self assert: (match positionOf: juan) currentSpace equals: 18.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 12.
	match play: repeatCard by: martin.
	self assert: (match cardsOf: martin) equals: {} asOrderedCollection.
	self assert: (match positionOf: fabio) currentSpace equals: 16
]

{ #category : #tests }
MatchTest >> testAllEffectsInOneMatch [
	| fabio cristian juan match board dices players deck |
	deck := self deckWithOverloadCard.
	dices := OrderedCollection
		with: (Dice deterministicWithFaces: 5 throwing: #(1 5 3 4 1))
		with: (Dice deterministicWithFaces: 4 throwing: #(2 4 2 1 2)).
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new.
			(MoonWalkEffect moving: 2).
			SpeedUpEffect new.
			WormHoleEffect new}.
	fabio := self playerNamedFabio.
	cristian := Player named: 'Cristian'.
	juan := self playerNamedJuan .
	players := OrderedCollection with: fabio with: cristian with: juan.
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 8.
	match playedBy: cristian.
	self assert: (match positionOf: cristian) currentSpace equals: 6.
	match playedBy: juan.
	self assert: (match positionOf: juan) currentSpace equals: 6.
	match playedBy: fabio.
	self
		assert: (match positionOf: fabio) currentSpace equals: 13;
		assert: (match positionOf: cristian) currentSpace equals: 4;
		assert: (match positionOf: juan) currentSpace equals: 4.
	match playedBy: cristian.
	self
		assert: (match positionOf: fabio) currentSpace equals: 1;
		assert: (match positionOf: cristian) currentSpace equals: 1;
		assert: (match positionOf: juan) currentSpace equals: 1
]

{ #category : #tests }
MatchTest >> testAskingAPositionOfPlayerThatIsNotPlaying [
	| fabio andres match board dices players deck |
	deck := self deckWithOverloadCard.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 5 throwing: #(5)).
	board := Board
		withSpaces: 10
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	fabio := self playerNamedFabio.
	andres := Player named: 'Andres'.
	players := OrderedCollection with: fabio.
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	self assert: (match positionOf: fabio) currentSpace equals: 1.
	self
		should: [ match positionOf: andres ]
		raise: MatchException 
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'Player ' , andres name , ' is not playing' ]
]

{ #category : #tests }
MatchTest >> testCreatingMatchAndAllPlayersStartAtSpace1 [
	| fabio cristian match board dices players deck |
	deck := self deckWithOverloadCard.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 5 throwing: #(1)).
	board := Board
		withSpaces: 10
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	fabio := self playerNamedFabio.
	cristian := Player named: 'Cristian'.
	players := OrderedCollection with: fabio with: cristian.
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	self assert: (match positionOf: fabio) currentSpace equals: 1.
	self assert: (match positionOf: cristian) currentSpace equals: 1
]

{ #category : #tests }
MatchTest >> testDealingInitialHandToPlayer [
	| juan match board dice deck overloadCard speedCard redoCard |
	juan := self playerNamedJuan.
	board := self boardWith10SpacesWithoutEffects.
	dice := Dice deterministicWithFaces: 5 throwing: {1}.
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	deck := Deck
		deterministicWithCardSequence:
			{speedCard.
			overloadCard.
			redoCard}
		andAmountOfCards: 50.
	match := Match
		playedBy: {juan}
		throwing: {dice}
		during: 3
		on: board
		dealingFrom: deck.
	self
		assert: (match cardsOf: juan)
		equals:
			{speedCard.
			overloadCard} asOrderedCollection
]

{ #category : #tests }
MatchTest >> testDeckRunsOutOfCardsAndDiscardDeckDoesNotHaveCards [
	| match board martin juan dices players deck speedCard accelerationCard |
	speedCard := SpeedCard new.
	accelerationCard := AccelerationCard new.
	deck := Deck
		deterministicWithCardSequence:
			{speedCard.
			accelerationCard}
		andAmountOfCards: 2.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			DealCardEffect new}.
	juan := self playerNamedJuan.
	martin := self playerNamedMartin.
	players := OrderedCollection with: martin with: juan.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(1 2)).
	match := Match
		playedBy: players
		throwing: dices
		during: 3
		on: board
		dealingFrom: deck.
	match play: speedCard targeting: martin by: martin.
	match play: accelerationCard by: martin.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 4;
		assert: (match positionOf: martin) currentLap equals: 0.
	self assert: match cardsOfDiscardDeck equals: {} asOrderedCollection.
	self assert: (match cardsOf: martin) equals: {} asOrderedCollection.
	self assert: (match cardsOf: juan) equals: {} asOrderedCollection.
	match playedBy: juan.
	self
		assert: (match positionOf: juan) currentSpace equals: 4;
		assert: (match positionOf: juan) currentLap equals: 0.
	self assert: match cardsOfDiscardDeck equals: {} asOrderedCollection.
	self assert: (match cardsOf: martin) equals: {} asOrderedCollection.
	self assert: (match cardsOf: juan) equals: {} asOrderedCollection
]

{ #category : #tests }
MatchTest >> testDeckRunsOutOfCardsButItGetsShuffled [
	| match board martin dices players deck repeatCard redoCard dealedCard |
	repeatCard := RepeatCard new.
	redoCard := RedoCard new.
	deck := Deck
		deterministicWithCardSequence:
			{repeatCard.
			redoCard}
		andAmountOfCards: 2.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			DealCardEffect new}.
	martin := self playerNamedMartin.
	players := OrderedCollection with: martin.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(2 1)).
	match := Match
		playedBy: players
		throwing: dices
		during: 3
		on: board
		dealingFrom: deck.
	match play: redoCard by: martin.
	match play: repeatCard by: martin.
	self
		should: [ deck dealCard ]
		raise: MatchException
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'There is no cards in the deck' ].
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 3;
		assert: (match positionOf: martin) currentLap equals: 0.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 4;
		assert: (match positionOf: martin) currentLap equals: 0.
	self
		assert:
			((match cardsOf: martin) = {repeatCard} asOrderedCollection or: [ (match cardsOf: martin) = {redoCard} asOrderedCollection ]).
	dealedCard := deck dealCard.
	self assert: (dealedCard className = 'RedoCard' or: [ dealedCard className = 'RepeatCard' ]).
	self
		should: [ deck dealCard ]
		raise: MatchException
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'There is no cards in the deck' ]
]

{ #category : #tests }
MatchTest >> testNoPlayerPlaysAndThereIsNoWinner [
	| match board mateo marcos players dices deck |
	deck := self deckWithOverloadCard.
	board := Board
		withSpaces: 30
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	mateo := Player named: 'Mateo'.
	marcos := Player named: 'Marcos'.
	players := OrderedCollection with: mateo with: marcos.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(1)).
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	self
		assert: (match positionOf: mateo) currentSpace equals: 1;
		assert: (match positionOf: mateo) currentLap equals: 0;
		assert: (match positionOf: marcos) currentSpace equals: 1;
		assert: (match positionOf: marcos) currentLap equals: 0.
	self
		should: [ match winner ]
		raise: MatchException
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'There is no winner' ]
]

{ #category : #tests }
MatchTest >> testOnlyInstantCardsAreDiscardedInstantlyWhenPlayed [
	| match board martin dices players deck repeatCard redoCard speedCard cancellationCard overloadCard accelerationCard |
	repeatCard := RepeatCard new.
	redoCard := RedoCard new.
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	overloadCard := OverloadCard new.
	accelerationCard := AccelerationCard new.
	deck := Deck
		deterministicWithCardSequence:
			{repeatCard.
			redoCard.
			speedCard.
			cancellationCard.
			accelerationCard.
			overloadCard}
		andAmountOfCards: 10.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			DealCardEffect new}.
	martin := self playerNamedMartin.
	players := OrderedCollection with: martin.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(2 1 1 2 1)).
	match := Match
		playedBy: players
		throwing: dices
		during: 3
		on: board
		dealingFrom: deck.
	match play: redoCard by: martin.
	self assert: match cardsOfDiscardDeck equals: {redoCard} asOrderedCollection.
	match play: repeatCard by: martin.
	self
		assert: match cardsOfDiscardDeck
		equals:
			{redoCard.
			repeatCard} asOrderedCollection.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 3;
		assert: (match positionOf: martin) currentLap equals: 0.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 4;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: speedCard by: martin.
	self deny:(match cardsOfDiscardDeck includes: speedCard).
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 6;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: cancellationCard by: martin targeting: speedCard.
	self
		assert: match cardsOfDiscardDeck
		equals:
			{redoCard.
			repeatCard.
			speedCard.
			cancellationCard} asOrderedCollection.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 8;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: accelerationCard by: martin.
	self deny: (match cardsOfDiscardDeck includes: accelerationCard) .
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 10;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: overloadCard by: martin.
	self deny: (match cardsOfDiscardDeck includes: overloadCard).
	self
		assert: match cardsOfDiscardDeck
		equals:
			{redoCard.
			repeatCard.
			speedCard.
			cancellationCard} asOrderedCollection
]

{ #category : #tests }
MatchTest >> testPermanentCardsAreSentToDiscardDeckByCancellationCard [
	| match board martin dices players deck redoCard speedCard firstCancellationCard overloadCard accelerationCard secondCancellationCard |
	redoCard := RedoCard new.
	speedCard := SpeedCard new.
	firstCancellationCard := CancellationCard new.
	secondCancellationCard := CancellationCard new.
	overloadCard := OverloadCard new.
	accelerationCard := AccelerationCard new.
	deck := Deck
		deterministicWithCardSequence:
			{speedCard.
			accelerationCard.
			overloadCard.
			firstCancellationCard.
			secondCancellationCard.
			redoCard}
		andAmountOfCards: 10.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{NoEffect new.
			DealCardEffect new}.
	martin := self playerNamedMartin.
	players := OrderedCollection with: martin.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(1 2 3 4)).
	match := Match
		playedBy: players
		throwing: dices
		during: 3
		on: board
		dealingFrom: deck.
	match play: speedCard targeting: martin by: martin.
	match play: accelerationCard by: martin.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 4;
		assert: (match positionOf: martin) currentLap equals: 0.
	self assert: match cardsOfDiscardDeck isEmpty.
	match play: overloadCard targeting: martin by: martin.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 6;
		assert: (match positionOf: martin) currentLap equals: 0.
	self assert: match cardsOfDiscardDeck isEmpty.
	match play: firstCancellationCard by: martin targeting: speedCard.
	self
		assert: match cardsOfDiscardDeck
		equals:
			{speedCard.
			firstCancellationCard} asOrderedCollection.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 8;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: secondCancellationCard by: martin targeting: accelerationCard.
	self
		assert: match cardsOfDiscardDeck
		equals:
			{speedCard.
			firstCancellationCard.
			accelerationCard.
			secondCancellationCard} asOrderedCollection.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 10;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: redoCard by: martin targeting: overloadCard.
	self
		assert: match cardsOfDiscardDeck
		equals:
			{speedCard.
			firstCancellationCard.
			accelerationCard.
			secondCancellationCard.
			overloadCard.
			redoCard} asOrderedCollection
]

{ #category : #tests }
MatchTest >> testPlayerMovesForwardOnBoard [
	| fabio match dices board players deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	fabio := self playerNamedFabio.
	players := OrderedCollection with: fabio.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 5 throwing: #(4)) with: (Dice deterministicWithFaces: 3 throwing: #(3)).
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	self assert: (match positionOf: fabio) currentSpace equals: 1.
	match playedBy: fabio.
	self assert: (match positionOf: fabio) currentSpace equals: 8
]

{ #category : #tests }
MatchTest >> testPlayerPlaysACardFromDeckShuffled [
	| match board martin dices players deck repeatCard |
	repeatCard := RepeatCard new.
	deck := Deck deterministicWithCardSequence: {repeatCard} andAmountOfCards: 1.
	board := Board
		withSpaces: 20
		andEffectsGeneratedFrom:
			{AtomicBombEffect new.
			DealCardEffect new}.
	martin := self playerNamedMartin.
	players := OrderedCollection with: martin.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(2 1 1)).
	match := Match
		playedBy: players
		throwing: dices
		during: 3
		on: board
		dealingFrom: deck.
	self assert: (match cardsOf: martin) equals: {repeatCard} asOrderedCollection.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 1;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: repeatCard by: martin.
	self assert: (match cardsOf: martin) equals: {} asOrderedCollection.
	self
		should: [ deck dealCard ]
		raise: MatchException
		withExceptionDo: [ :exception | self assert: exception messageText equals: 'There is no cards in the deck' ].
	self
		assert: (match positionOf: martin) currentSpace equals: 1;
		assert: (match positionOf: martin) currentLap equals: 0.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 2;
		assert: (match positionOf: martin) currentLap equals: 0.
	self assert: (match cardsOf: martin) equals: {repeatCard} asOrderedCollection.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 1;
		assert: (match positionOf: martin) currentLap equals: 0.
	match play: repeatCard by: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 1;
		assert: (match positionOf: martin) currentLap equals: 0.
]

{ #category : #tests }
MatchTest >> testPlayerWantsToPlayACardButHeIsNotPartOfTheMatch [
	| juan martin board dice deck match speedCard |
	juan := self playerNamedJuan.
	martin := self playerNamedMartin.
	board := self boardWith10SpacesWithoutEffects.
	speedCard := SpeedCard new.
	deck := Deck
		deterministicWithCardSequence: {speedCard}
		andAmountOfCards: 50.
	dice := Dice deterministicWithFaces: 6 throwing: {5}.
	match := Match
		playedBy: {juan}
		throwing: {dice}
		during: 3
		on: board
		dealingFrom: deck.
	self
		should: [ match play: speedCard targeting: juan by: martin ]
		raise: MatchException
		withExceptionDo: [ :exception | 
			self
				assert: exception messageText
				equals: 'Player ' , martin name , ' is not playing' ]
]

{ #category : #tests }
MatchTest >> testPlayerWantsToPlayACardButTheMatchHasFinished [
	| fabio match dices board players accelerationCard deck |
	accelerationCard := AccelerationCard new.
	board := self boardWith10SpacesWithoutEffects.
	fabio := self playerNamedFabio.
	players := OrderedCollection with: fabio.
	dices := OrderedCollection
		with: (Dice deterministicWithFaces: 10 throwing: {10}).
	deck := Deck
		deterministicWithCardSequence: {accelerationCard}
		andAmountOfCards: 50.
	match := Match
		playedBy: players
		throwing: dices
		during: 1
		on: board
		dealingFrom: deck.
	match playedBy: fabio.
	self
		should: [ match play: accelerationCard by: fabio ]
		raise: MatchException
		withExceptionDo:
			[ :exception | self assert: exception messageText equals: 'The match is over' ]
]

{ #category : #tests }
MatchTest >> testPlayerWantsToPlayACardToAPlayerThatIsNotPlaying [
	| juan martin board dice deck match speedCard |
	juan := self playerNamedJuan.
	martin := self playerNamedMartin.
	board := self boardWith10SpacesWithoutEffects.
	speedCard := SpeedCard new.
	deck := Deck
		deterministicWithCardSequence: {speedCard}
		andAmountOfCards: 50.
	dice := Dice deterministicWithFaces: 6 throwing: {5}.
	match := Match
		playedBy: {juan}
		throwing: {dice}
		during: 3
		on: board
		dealingFrom: deck.
	self
		should: [ match play: speedCard targeting: martin by: juan ]
		raise: MatchException
		withExceptionDo: [ :exception | 
			self
				assert: exception messageText
				equals: 'Player ' , martin name , ' is not playing' ]
]

{ #category : #tests }
MatchTest >> testPlayerWantsToPlayAPermanentCardButItIsNotHisTurn [
	| juan martin board dice deck match speedCard |
	juan := self playerNamedJuan.
	martin := self playerNamedMartin.
	board := self boardWith10SpacesWithoutEffects.
	speedCard := SpeedCard new.
	deck := Deck
		deterministicWithCardSequence: {speedCard}
		andAmountOfCards: 50.
	dice := Dice deterministicWithFaces: 6 throwing: {5}.
	match := Match
		playedBy:
			{juan.
			martin}
		throwing: {dice}
		during: 3
		on: board
		dealingFrom: deck.
	self
		should: [ match play: speedCard targeting: juan by: martin ]
		raise: MatchException
		withExceptionDo: [ :exception | 
			self
				assert: exception messageText
				equals: 'A player can only play a permanent card in his turn' ]
]

{ #category : #tests }
MatchTest >> testPlayersRankings [
	| luciana micaela carolina victoria match board dices players deck |
	deck := self deckWithOverloadCard.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 5 throwing: #(1 3 5 4)).
	board := self boardWith10SpacesWithoutEffects.
	luciana := Player named: 'Luciana'.
	micaela := Player named: 'Micaela'.
	carolina := Player named: 'Carolina'.
	victoria := Player named: 'Victoria'.
	players := OrderedCollection
		with: luciana
		with: micaela
		with: carolina
		with: victoria.
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	match
		playedBy: luciana;
		playedBy: micaela;
		playedBy: carolina;
		playedBy: victoria.
	self
		assert: (match rankingOf: luciana) equals: 4;
		assert: (match rankingOf: micaela) equals: 3;
		assert: (match rankingOf: carolina) equals: 1;
		assert: (match rankingOf: victoria) equals: 2
]

{ #category : #tests }
MatchTest >> testPlayersSequenceInMatch [
	| board martin juan match players dices deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	martin := self playerNamedMartin.
	juan := self playerNamedJuan.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 6 throwing: #(1 2 3 4)).
	players := OrderedCollection with: martin with: juan.
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	self assert: match nextPlayer name equals: 'Martin'.
	match playedBy: martin.
	self assert: match nextPlayer name equals: 'Juan'.
	match playedBy: juan.
	self assert: match nextPlayer name equals: 'Martin'.
	match playedBy: martin.
	self assert: match nextPlayer name equals: 'Juan'.
	match playedBy: juan.
	self assert: match nextPlayer name equals: 'Martin'
]

{ #category : #tests }
MatchTest >> testPositionOfPlayers [
	| match board martin juan dices players deck |
	deck := self deckWithOverloadCard.
	board := self boardWith10SpacesWithoutEffects.
	martin := self playerNamedMartin.
	juan := self playerNamedMartin.
	players := OrderedCollection with: martin with: juan.
	dices := OrderedCollection
		with: (Dice deterministicWithFaces: 6 throwing: #(3 2 5))
		with: (Dice deterministicWithFaces: 5 throwing: #(2 5 4))
		with: (Dice deterministicWithFaces: 5 throwing: #(1 2 3))
		with: (Dice deterministicWithFaces: 8 throwing: #(7 6 1))
		with: (Dice deterministicWithFaces: 2 throwing: #(1 2 1)).
	match := Match
		playedBy: players
		throwing: dices
		during: 9
		on: board
		dealingFrom: deck.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 5;
		assert: (match positionOf: martin) currentLap equals: 1.
	match playedBy: juan.
	self
		assert: (match positionOf: juan) currentSpace equals: 8;
		assert: (match positionOf: juan) currentLap equals: 1.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 9;
		assert: (match positionOf: martin) currentLap equals: 2.
	match playedBy: juan.
	self
		assert: (match positionOf: juan) currentSpace equals: 2;
		assert: (match positionOf: juan) currentLap equals: 3.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 6;
		assert: (match positionOf: martin) currentLap equals: 4.
	match playedBy: juan.
	self
		assert: (match positionOf: juan) currentSpace equals: 6;
		assert: (match positionOf: juan) currentLap equals: 4.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 10;
		assert: (match positionOf: martin) currentLap equals: 5.
	match playedBy: juan.
	self
		assert: (match positionOf: juan) currentSpace equals: 3;
		assert: (match positionOf: juan) currentLap equals: 6.
	match playedBy: martin.
	self
		assert: (match positionOf: martin) currentSpace equals: 4;
		assert: (match positionOf: martin) currentLap equals: 7.
	match playedBy: juan.
	self
		assert: (match positionOf: juan) currentSpace equals: 7;
		assert: (match positionOf: juan) currentLap equals: 7.
	match playedBy: martin.
	self
		assert: (match positionOf: juan) currentSpace equals: 7;
		assert: (match positionOf: juan) currentLap equals: 7;
		assert: (match positionOf: martin) currentSpace equals: 1;
		assert: (match positionOf: martin) currentLap equals: 9
]

{ #category : #tests }
MatchTest >> testWhenMatchIsCreatedWithOnePlayerItIsHisTurn [
	| matias match dices board players deck |
	deck := self deckWithOverloadCard.
	dices := OrderedCollection with: (Dice deterministicWithFaces: 5 throwing: #(1)).
	board := Board
		withSpaces: 10
		andEffectsGeneratedFrom:
			{NoEffect new.
			AtomicBombEffect new}.
	matias := Player named: 'Matias'.
	players := OrderedCollection with: matias.
	match := Match
		playedBy: players
		throwing: dices
		during: 2
		on: board
		dealingFrom: deck.
	self assert: match nextPlayer name equals: 'Matias'
]
