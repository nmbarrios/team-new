Class {
	#name : #DiscardDeckTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DiscardDeckTest >> testAddingCardsAndShufflingADiscardDeck [
	| discardDeck speedCard overloadCard accelerationCard deckShuffled |
	discardDeck := DiscardDeck new.
	speedCard := SpeedCard new.
	overloadCard := OverloadCard new.
	accelerationCard := AccelerationCard new.
	discardDeck
		addFromMatch: speedCard;
		addFromMatch: overloadCard;
		addFromMatch: accelerationCard.
	deckShuffled := discardDeck shuffle.
	self
		assert:
			((deckShuffled includes: speedCard)
				and: [ (deckShuffled includes: overloadCard)
						and: [ (deckShuffled includes: accelerationCard) and: [ deckShuffled size = 3 ] ] ])
]
