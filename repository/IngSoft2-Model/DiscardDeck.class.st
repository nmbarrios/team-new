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
	cards add:aCard.
]

{ #category : #initialization }
DiscardDeck >> initialize [
	cards := OrderedCollection new
]

{ #category : #shuffling }
DiscardDeck >> shuffle [
	| cardsShuffled |
	cardsShuffled:= OrderedCollection newFrom: (cards shuffled).
	cards removeAll.
	^ cardsShuffled
]
