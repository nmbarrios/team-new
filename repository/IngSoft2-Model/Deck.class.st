Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Deck class >> assertIsEmpty: cardSuccession [
	cardSuccession isEmpty
		ifTrue: [ MatchException
				signal: 'The card succession must have at least one card' ]
]

{ #category : #'creation validation' }
Deck class >> checkIsValid: anAmountOfCards [
	anAmountOfCards > 0
		ifFalse: [ MatchException signal: 'The amount of cards in the deck must be at least 1' ]
]

{ #category : #'instance creation' }
Deck class >> deterministicWithCardSequence: cardSuccession andAmountOfCards: anAmountOfCards [
	self assertIsEmpty: cardSuccession.
	self checkIsValid: anAmountOfCards.
	^ self generatedBy: (DeterministicDeckStrategy using: cardSuccession withSize: anAmountOfCards)
]

{ #category : #'instance creation' }
Deck class >> generatedBy: aDeckStrategy [ 
	^ self new initializeWith: aDeckStrategy 
]

{ #category : #'instance creation' }
Deck class >> randomWithAmountOfCards: anAmountOfCards [
	self checkIsValid: anAmountOfCards.
	^ self generatedBy: (RandomDeckStrategy withSize: anAmountOfCards)
]

{ #category : #dealing }
Deck >> dealCard [
	cards isEmpty
		ifTrue: [ MatchException signal: 'There is no cards in the deck' ].
	^ cards removeFirst
]

{ #category : #generating }
Deck >> generatedFrom: aDiscardDeck [
	cards addAll: aDiscardDeck.
]

{ #category : #initialization }
Deck >> initializeWith: aDeckStrategy [
	cards := aDeckStrategy cards asOrderedCollection 
]
