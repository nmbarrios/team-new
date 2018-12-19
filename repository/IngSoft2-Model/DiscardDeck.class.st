Class {
	#name : #DiscardDeck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #adding }
DiscardDeck >> addFromMatch: aCard [
	cards add: aCard
]

{ #category : #description }
DiscardDeck >> assertDiscardDeckIsEmpty [
	cards isEmpty
		ifTrue: [ MatchException signal: 'You can not shuffle a discard deck with no cards' ]
]

{ #category : #accessing }
DiscardDeck >> cards [
	^ cards
]

{ #category : #initialization }
DiscardDeck >> initialize [
	cards := OrderedCollection new
]

{ #category : #shuffling }
DiscardDeck >> shuffled [
	| cardsShuffled |
	self assertDiscardDeckIsEmpty.
	cardsShuffled := cards shuffled asOrderedCollection.
	cards removeAll.
	^ cardsShuffled
]
