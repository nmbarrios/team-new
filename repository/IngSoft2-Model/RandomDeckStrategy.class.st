Class {
	#name : #RandomDeckStrategy,
	#superclass : #Object,
	#instVars : [
		'cards',
		'cardSequence'
	],
	#classInstVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
RandomDeckStrategy class >> withAmountOfCards: anAmountOfCards [
^ self new initializeWithAmountOfCards: anAmountOfCards.
]

{ #category : #accessing }
RandomDeckStrategy >> cards [
	^ cardSequence 
]

{ #category : #initialization }
RandomDeckStrategy >> initializeWithAmountOfCards: anAmountOfCards [
	cards := OrderedCollection new
		add: RedoCard new;
		add: RepeatCard new;
		add: SpeedCard new;
		add: OverloadCard new;
		add: AccelerationCard new;
		add: CancellationCard new;
		yourself.
	cardSequence := (1 to: anAmountOfCards) collect: [ :card | cards atRandom ]
]
