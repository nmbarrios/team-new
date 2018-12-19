Class {
	#name : #DeterministicDeckStrategy,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'instance creation' }
DeterministicDeckStrategy class >> using: aSequence withSize: anAmountOfCards [
	^ self new initializeUsing: aSequence withAmountOfCards: anAmountOfCards 
]

{ #category : #accessing }
DeterministicDeckStrategy >> cards [
	^ cards
	
]

{ #category : #initialization }
DeterministicDeckStrategy >> initializeUsing: aSequence withAmountOfCards: anAmountOfCards [
	| deterministicStrategy |
	deterministicStrategy := DeterministicStrategy using: aSequence.
	cards := (1 to: anAmountOfCards) collect: [ :card | deterministicStrategy next ]
]
