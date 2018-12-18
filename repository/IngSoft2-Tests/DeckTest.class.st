Class {
	#name : #DeckTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DeckTest >> testCreatingDeckWithInvalidAmountOfCards [
| deck |
	self
		should: [ deck := Deck deterministicWithCardSequence: {OverloadCard new. AccelerationCard new} andAmountOfCards: -5 ]
		raise: MatchException
		withExceptionDo: [ :exception | 
			self
				assert: exception messageText
				equals: 'The amount of cards in the deck must be at least 1' ]
]

{ #category : #tests }
DeckTest >> testCreatingDeterministicDeckWithAnEmptyCardSuccession [
	| deck |
	self
		should: [ deck := Deck deterministicWithCardSequence: {} andAmountOfCards: 50 ]
		raise: MatchException
		withExceptionDo: [ :exception | 
			self
				assert: exception messageText
				equals: 'The card succession must have at least one card' ]
]

{ #category : #tests }
DeckTest >> testDealingCardFromDeckWithDeterministicStrategy [
	| deck overloadCard speedCard |
	overloadCard := OverloadCard new.
	speedCard := SpeedCard new.
	deck := Deck
		deterministicWithCardSequence:
			{overloadCard.
			speedCard}
		andAmountOfCards: 50.
	self
		assert: deck dealCard equals: overloadCard;
		assert: deck dealCard equals: speedCard;
		assert: deck dealCard equals: overloadCard
]

{ #category : #tests }
DeckTest >> testDealingCardFromDeckWithRandomStrategy [
	| deck card |
	deck := Deck randomWithAmountOfCards: 50.
	card := deck dealCard.
	self
		assert:
			(card class = OverloadCard
				or: [ card class = SpeedCard
						or: [ card class = RepeatCard
								or: [ card class = RedoCard
										or:
											[ card class = CancellationCard or: [ card class = AccelerationCard ] ] ] ] ])
]

{ #category : #tests }
DeckTest >> testDeckRunsOutOfCards [
	| deck |
	deck := Deck
		deterministicWithCardSequence:
			{OverloadCard new.
			SpeedCard new.
			AccelerationCard new}
		andAmountOfCards: 5.
	self assert: deck dealCard className asString equals: 'OverloadCard'.
	self assert: deck dealCard className asString equals: 'SpeedCard'.
	self assert: deck dealCard className asString equals: 'AccelerationCard'.
	self assert: deck dealCard className asString equals: 'OverloadCard'.
	self assert: deck dealCard className asString equals: 'SpeedCard'.
	self should: [
	deck dealCard]
	raise: MatchException 
	withExceptionDo: [ :exception | self assert: exception messageText equals: 'There is no cards in the deck' ]
]
